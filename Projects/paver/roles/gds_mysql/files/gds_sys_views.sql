-- # make sure 'sys' schema is installed #
--  if this shows the db then skip the next step, otherwise load up the sys schema from the shell (this must be done on BOTH hosts in the cluster):
-- # NOTE that version may change, usethe path it prints out for you...
--   cd ~/
--   git clone https://github.com/mysql/mysql-sys.git
--   cd mysql-sys
--   ./generate_sql_file.sh -v 56
--   mysql < gen/sys_1.5.1_56_inline.sql

UPDATE sys.sys_config SET value=256 WHERE variable='statement_truncate_len';

-- define users you're interested in #
USE performance_schema;
DELETE FROM setup_actors WHERE HOST='%' AND USER='%' AND ROLE='%';
INSERT IGNORE INTO setup_actors VALUES('1%', '%', '%');

-- define objects to monitor #
USE performance_schema;
INSERT IGNORE INTO setup_objects VALUES('TABLE', 'percona', '%', 'NO', 'NO');
INSERT IGNORE INTO setup_objects VALUES('TABLE', 'sys', '%', 'NO', 'NO');

-- define the info we log #
USE performance_schema;
UPDATE setup_consumers SET ENABLED='YES' WHERE NAME IN ('statements_digest', 'thread_instrumentation', 'global_instrumentation', 'events_statements_current', 'events_statements_history', 'events_statements_history_long');

-- setup statement measuring #
USE performance_schema;
UPDATE setup_instruments SET ENABLED='YES' WHERE NAME LIKE 'statement%';
UPDATE setup_instruments SET TIMED='YES' WHERE NAME LIKE 'statement%';
UPDATE setup_instruments SET ENABLED='YES' WHERE NAME LIKE 'stage/sql%';
UPDATE setup_instruments SET TIMED='YES' WHERE NAME LIKE 'stage/sql%';

-- OPTIONAL create the utility user #
-- GRANT USAGE ON *.* TO 'users_service_utl'@'%' IDENTIFIED BY PASSWORD 'putapasswordhere';
-- GRANT SELECT ON sys.* to 'users_service_utl'@'%';
-- GRANT SELECT ON performance_schema.* to 'users_service_utl'@'%';


-- views
USE sys;

CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_slow_queries_by_total AS SELECT total_latency, exec_count, avg_latency, lock_latency, round((rows_sent_avg / rows_examined_avg)*100, 2) pct_rows_sent, tmp_tables, rows_sorted, first_seen, last_seen, digest, left(query, 24) query_text_short FROM sys.statement_analysis WHERE db NOT IN ('mysql', 'percona') LIMIT 40;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_slow_queries_text AS SELECT digest, query FROM sys.statement_analysis WHERE db NOT IN ('mysql', 'percona') LIMIT 40;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_frequent_queries AS SELECT exec_count, total_latency, avg_latency, lock_latency, round((rows_sent_avg / rows_examined_avg)*100, 2) pct_rows_sent, tmp_tables, rows_sorted, first_seen, last_seen, digest, left(query, 24) query_text_short FROM sys.statement_analysis WHERE db NOT IN ('mysql', 'percona') ORDER BY exec_count DESC LIMIT 40;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_95th_pct_slow_queries AS SELECT total_latency, exec_count, avg_latency, round((rows_sent_avg / rows_examined_avg)*100, 2) pct_rows_sent, first_seen, last_seen, digest, left(query, 24) query_text_short FROM statements_with_runtimes_in_95th_percentile  WHERE db NOT IN ('mysql', 'percona') LIMIT 40;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_queries_with_error AS SELECT errors, error_pct, warnings, warning_pct, first_seen, last_seen, digest, left(query, 24) query_text_short FROM sys.statements_with_errors_or_warnings WHERE db NOT IN ('mysql', 'sys', 'percona') LIMIT 40;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_redundant_idx AS SELECT CONCAT(table_schema, '.', table_name) tbl, redundant_index_name dup_idx, dominant_index_name idx FROM sys.schema_redundant_indexes ORDER BY 1,2;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_unused_idx AS SELECT CONCAT(object_schema, '.', object_name) tbl, index_name unused_idx FROM schema_unused_indexes ORDER BY 1,2;;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW gds_table_access_stats AS SELECT CONCAT(table_schema, '.', table_name) tbl, total_latency, rows_fetched, rows_inserted, rows_updated, rows_deleted, io_read_requests, io_read_latency, io_write_requests, io_write_latency, io_misc_requests, io_misc_latency FROM schema_table_statistics WHERE (rows_fetched + rows_inserted + rows_updated + rows_deleted) > 1 AND total_latency NOT LIKE '%us' AND total_latency NOT LIKE '%ps' LIMIT 40;

-- report procedures
USE sys;

DROP PROCEDURE IF EXISTS gds_report_all;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `gds_report_all`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT ''
BEGIN
  SELECT '--------  FULL REPORT  --------';
  SELECT NOW();
  SELECT '-----   SLOW QUERIES BY CUMULATIVE TIME TAKEN  -----';
  SELECT * FROM gds_slow_queries_by_total;
  SELECT '-----   QUERY DETAILS FOR SLOWEST QUERIES  -----';
  SELECT * FROM gds_slow_queries_text;
  SELECT '-----   MOST FREQUENT QUERIES BEING RUN  -----';
  SELECT * FROM gds_frequent_queries;
  SELECT '-----   QUERIES IN THE 95th PERCENTILE OF SLOW INDIVIDUALLY  -----';
  SELECT * FROM gds_95th_pct_slow_queries;
  SELECT '-----   QUERIES WHICH ARE RECEIVING ERRORS  -----';
  SELECT * FROM gds_queries_with_error;
  SELECT '-----   BUSIEST TABLES IN THE SCHEMA -----';
  SELECT * FROM gds_table_access_stats;
  SELECT '-----   DUPLICATE INDEXES IN THE SCHEMA  -----';
  SELECT * FROM gds_redundant_idx;
  SELECT '-----   INDEXES NOT BEING USED AT ALL  -----';
  SELECT * FROM gds_unused_idx;
  SELECT '--------  END OF REPORT  --------';
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS gds_report_slow_queries;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `gds_report_slow_queries`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT ''
BEGIN
  SELECT '--------  SLOW QUERIES REPORT  --------';
  SELECT NOW();
  SELECT '-----   SLOW QUERIES BY CUMULATIVE TIME TAKEN  -----';
  SELECT * FROM gds_slow_queries_by_total;
  SELECT '-----   QUERY DETAILS FOR SLOWEST QUERIES  -----';
  SELECT * FROM gds_slow_queries_text;
  SELECT '-----   MOST FREQUENT QUERIES BEING RUN  -----';
  SELECT * FROM gds_frequent_queries;
  SELECT '-----   QUERIES IN THE 95th PERCENTILE OF SLOW INDIVIDUALLY  -----';
  SELECT * FROM gds_95th_pct_slow_queries;
  SELECT '-----   QUERIES WHICH ARE RECEIVING ERRORS  -----';
  SELECT * FROM gds_queries_with_error;
  SELECT '--------  END OF REPORT  --------';
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS gds_report_schema_info;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `gds_report_schema_info`()
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT ''
BEGIN
  SELECT '--------  SCHEMA REPORT  --------';
  SELECT NOW();
  SELECT '-----   BUSIEST TABLES IN THE SCHEMA -----';
  SELECT * FROM gds_table_access_stats;
  SELECT '-----   DUPLICATE INDEXES IN THE SCHEMA  -----';
  SELECT * FROM gds_redundant_idx;
  SELECT '-----   INDEXES NOT BEING USED AT ALL  -----';
  SELECT * FROM gds_unused_idx;
  SELECT '--------  END OF REPORT  --------';
END
//
DELIMITER ;