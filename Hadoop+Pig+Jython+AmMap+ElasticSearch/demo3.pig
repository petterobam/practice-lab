-- 接口访问频率统计


register 'file:/usr/local/Cellar/pig/0.17.0/libexec/lib/*.jar'

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
F = FILTER LOGS_BASE BY INDEXOF(url, '.json', 0)>= 0;
-- A = FOREACH F GENERATE 	SUBSTRING(url, 0, (INDEXOF(url, '?', 0) < 0 ? SIZE(url) - 1 : INDEXOF(url, '?', 0))) as url;
-- Dump A;
F0 = FILTER F BY INDEXOF(url, '?', 0) >= 0;
F1 = FOREACH F0 GENERATE ip,timestamp,SUBSTRING(url, 0 , INDEXOF(url, '?')) as url,status,bytes;
F2 = FILTER F BY INDEXOF(url, '?', 0) < 0;
F3 = UNION F1, F2;
F4 = FOREACH F3 GENERATE  ip,timestamp,REPLACE(url, '(GET|POST|HTTP\\/1\\.1)', '') as url,status,bytes;

B = GROUP F4 BY (url);
-- B = GROUP A BY (url);
-- C = FOREACH B GENERATE COUNT(LOGS_BASE.ip) as counts;
E = FOREACH B GENERATE COUNT(F4.url) as counts,FLATTEN(group);
-- DUMP E;
STORE E INTO 'data/demo3-E2' USING PigStorage(',');

-- 运行如下命令
-- pig -x local demo3.pig > output/demo3/log-`date "+%Y%m%d%H%M%S"`.log 2>&1