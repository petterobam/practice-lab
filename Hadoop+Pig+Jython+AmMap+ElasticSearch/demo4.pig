register file:/usr/local/Cellar/pig/0.17.0/libexec/lib/piggybank.jar;
register file:/usr/local/Cellar/pig/0.17.0/libexec/lib/elasticsearch-hadoop-pig-7.3.0.jar;

A = LOAD 'data/demo2-C1' USING PigStorage(',') as (country:chararray,city:chararray,longitude:float,latitude:float,counts:int);
B = FILTER A BY counts > 0;
STORE B INTO 'nginx_access_city/log_city_sum' USING org.elasticsearch.hadoop.pig.EsStorage();

-- pig -x local demo4.pig > output/demo4/log-`date +%Y%m%d%H%M%S`.log 2>&1