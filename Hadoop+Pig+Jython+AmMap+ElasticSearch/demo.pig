-- register file:/usr/local/Cellar/pig/0.17.0/libexec/lib/piggybank.jar;
-- register file:/usr/local/Cellar/pig/0.17.0/libexec/lib/elasticsearch-hadoop-pig-7.3.0.jar;
register 'file:/usr/local/Cellar/pig/0.17.0/libexec/lib/*.jar';

RAW_LOGS = LOAD 'access/localhost_access_log.2019-07-17-02.txt' USING TextLoader as (line:chararray);
-- Dump RAW_LOGS;
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
-- STORE LOGS_BASE INTO 'nginx/log_base' USING org.elasticsearch.hadoop.pig.EsStorage('es.http.timeout = 5m', 'es.index.auto.create = true');
-- STORE LOGS_BASE INTO 'data/demo-LOGS_BASE' USING PigStorage (',');
-- STORE LOGS_BASE INTO 'data/demo-LOGS_BASE';

-- Dump LOGS_BASE;
-- A = FOREACH LOGS_BASE GENERATE ToDate(timestamp, 'dd/MMM/yyyy:HH:mm:ss Z', 'Asia/Singapore') as date, ip, url,(int)status,(bytes == '-' ? 0 : (int)bytes) as bytes;
-- JDK1.8默认时区无法转化这种格式的 （17/Jul/2019:00:00:29 +0800） ，试了上百个时区，不知道具体是哪个时区，http://joda-time.sourceforge.net/timezones.html
A = FOREACH LOGS_BASE GENERATE ToDate(timestamp, 'dd/MMM/yyyy:HH:mm:ss Z', 'Etc/GMT+8') as date, ip, url,(int)status,(bytes == '-' ? 0 : (int)bytes) as bytes;
-- Dump A;
-- B = GROUP A BY (timestamp);
-- C = FOREACH B GENERATE FLATTEN(group) as (timestamp), COUNT(A) as count;
-- D = ORDER C BY timestamp,count desc;
-- STORE A INTO 'nginx/log' USING org.elasticsearch.hadoop.pig.EsStorage();
STORE A INTO 'data/demo-A' USING PigStorage (',');


-- 运行以下命令
-- pig -x local demo.pig > output/demo/log-`date "+%Y%m%d%H%M%S"`.log 2>&1