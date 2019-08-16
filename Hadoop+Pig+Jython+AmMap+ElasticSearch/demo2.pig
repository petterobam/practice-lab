register file:/usr/local/Cellar/pig/0.17.0/libexec/lib/piggybank.jar;
register file:/usr/local/Cellar/pig/0.17.0/libexec/lib/elasticsearch-hadoop-pig-7.3.0.jar;
register utils2.py using jython as utils;

RAW_LOGS = LOAD 'access/localhost_access_log.2019-07-17-02.txt' USING TextLoader as (line:chararray);

LOGS_BASE = FOREACH RAW_LOGS GENERATE
    FLATTEN(
      REGEX_EXTRACT_ALL(line, '(\\S+) - - \\[([^\\[]+)\\]\\s+"([^"]+)"\\s+(\\d+)\\s+(\\d+|-)\\s*')
    )
    AS (
        ip: chararray,
        timestamp: chararray,
        url: chararray,
        status: chararray,
        bytes: chararray
    );

A = FOREACH LOGS_BASE GENERATE timestamp as date, utils.get_country(ip) as country,
    utils.get_city(ip) as city, utils.get_geo(ip) as location,ip,
    url, (int)status,(bytes == '-' ? 0 : (int)bytes) as bytes;

-- STORE A INTO 'nginx_access/log' USING org.elasticsearch.hadoop.pig.EsStorage();

B = GROUP A BY (country,city,location);
C = FOREACH B GENERATE FLATTEN(group), COUNT(A.location) as counts;

STORE C INTO 'data/demo2-C1' USING PigStorage(',');

-- pig -x local demo2.pig > output/demo2/log-`date +%Y%m%d%H%M%S`.log 2>&1