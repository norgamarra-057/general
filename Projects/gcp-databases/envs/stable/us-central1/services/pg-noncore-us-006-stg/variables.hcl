  db_name = "pg_noncore_us_006_stg"
  db_instance_name = "pg-noncore-us-006-stg"
  db_type = "postgres"
  db_version = "POSTGRES_15"
  db_tier = "db-custom-8-30720"
  disk_size = 7075
  log_connections = "on"
  pg_cron = "on"
#  db_user_name = "my_test_app"
#  db_user_password = "gds123test"
  replica_count = 1
  max_worker_processes = 32
  max_logical_replication_workers = 24
  max_wal_senders = 25
  max_replication_slots = 20