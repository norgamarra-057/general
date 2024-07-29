SELECT object_schema AS table_schema,
       object_name AS table_name,
       index_name,
       count_read AS rows_read
  FROM performance_schema.table_io_waits_summary_by_index_usage
 WHERE index_name IS NOT NULL 
 AND object_schema not in ( 'mysql' , 'percona' ) 
 ORDER BY count_read 
 LIMIT 10 ;