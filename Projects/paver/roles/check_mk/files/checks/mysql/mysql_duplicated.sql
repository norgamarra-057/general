SELECT   s1.table_schema        idx_schema
,        s1.table_name          idx_table
,        s1.index_type          idx_type
,        s1.index_name          idx_name1
,        s2.index_name          idx_name2
FROM     information_schema.STATISTICS s1
JOIN     information_schema.STATISTICS s2
ON       s1.table_schema = s2.table_schema
AND      s1.table_name   = s2.table_name
AND      s1.index_type   = s2.index_type
AND      s1.index_name  != s2.index_name
AND      s1.seq_in_index = s2.seq_in_index
AND      s1.column_name  = s2.column_name
WHERE    s1.table_schema = schema()
AND      s1.table_name   = 'people'
GROUP BY s1.table_schema
,        s1.table_name
,        s1.index_type
,        s1.index_name
,        s2.index_name
;




