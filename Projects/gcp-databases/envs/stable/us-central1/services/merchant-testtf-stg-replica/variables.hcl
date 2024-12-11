  
  db_name = "merchant-testtf-stg-replica"
  db_instance_name = "merchant-testtf-stg-replica-0"
  #db_replica_name = "test-mysql-4-replica"
  db_version = "MYSQL_8_0"
  db_tier = "db-n1-standard-4"
  disk_size=200
  wait_timeout=20000
  general_log="off"
  max_connections=2000
  log_output="FILE"
  #long_query_time=1.2
  replica_count = 0
  
