variable "gcp_project_id" {
  description = "GCP project id where resources will be applied."
}

variable "gcp_region" {
  description = "GCP region where resources will be applied."
  type        = string
  default     = "us-central1"
}

variable "db_vpc_name" {
  description = "The name of the VPC the database will be placed in."
  type        = string
}


variable "vpc_name_project" {
  description = "The name of the VPC the database will be placed in."
  type        = string
}

variable "db_name" {
  description = "The name of the database."
  type        = string
}

variable "db_replica_name" {
  description = "The name of the database."
  type        = string
  default     = null
}

variable "db_instance_name" {
  description = "The name of the database instance."
  type        = string
}

variable "db_version" {
  description = "The engine version to use for the database."
  type        = string
  default     = "POSTGRES_15"  # Set the default to 15
}

variable "db_tier" {
  description = "The tiering or size for the database."
  type        = string
}

variable "db_type" {
  description = "The type of database (mysql or postgres)"
  type        = string
  default     = "postgres"  # Set the default type to postgres
}

variable "backup_configuration_enabled" {
  description = "Enable backup configuration"
  type        = bool
  default     = true
}

variable "replication_enabled" {
  description = "Enable replication"
  type        = bool
  default     = true
}

variable "cpu" {
  description = "Number of CPUs for the database instance"
  type        = number
  default     = "1"
}

variable "storage" {
  description = "Amount of storage for the database instance"
  type        = string
  default     = "10GB"
}

variable "max_connections" {
  type    = number
  default = 5669
}

# Memory-related parameters
variable "shared_buffers" {
  description = "Sets the amount of memory the database server uses for shared memory buffers."
  type        = string
  default = null
}

variable "effective_cache_size" {
  description = "Sets the planner's assumption about the effective size of the disk cache."
  type        = number
  default = null
}

variable "work_mem" {
  description = "Specifies the amount of memory to be used by internal sort operations and hash tables before switching to temporary disk files."
  type        = number
  default = 12999
}

# Add more memory-related parameters as needed

# Log-related parameters
variable "logging" {
  description = "Enables or disables PostgreSQL logging"
  default     = true
  type        = bool
}

variable "log_statement" {
  description = "Controls which SQL statements are logged"
  default     = "ddl"
  type        = string
}


# Replication parameters
variable "replication" {
  description = "Enables or disables replication"
  default     = true
  type        = bool
}

variable "maintenance_work_mem" {
  description = "Specifies the maximum amount of memory to be used by maintenance operations"
  type        = string
  default     = 100000
}

variable "wal_buffers" {
  description = "Sets the number of disk-page buffers in each write-ahead log"
  type        = string
  default     = null
}

variable "checkpoint_timeout" {
  description = "Sets the maximum time between automatic WAL checkpoints"
  type        = string
  default     = null
}

variable "max_wal_size" {
  description = "Sets the maximum size to which the WAL file can grow"
  type        = string
  default     = null
}

variable "min_wal_size" {
  description = "Sets the minimum size to which the WAL file can shrink"
  type        = string
  default     = null
}

variable "max_wal_senders" {
  description = "Sets the maximum number of simultaneously supported replication connections"
  type        = number
  default     = null
}

variable "max_replication_slots" {
  description = "Sets the maximum number of simultaneously defined replication slots"
  type        = number
  default     = null
}

variable "hot_standby_feedback" {
  description = "Enables the sending of information from the standby to the primary about transactions that are near a rollback point"
  type        = number
  default     = 1
}

variable "max_standby_streaming_delay" {
  description = "Sets the maximum number of background worker processes"
  type        = number
  default     = 300000
}

variable "max_standby_archive_delay" {
  description = "Sets the maximum number of background worker processes"
  type        = number
  default     = 300000
}

variable "max_worker_processes" {
  description = "Sets the maximum number of background worker processes"
  type        = number
  default     = null
}

variable "max_sync_workers_per_subscription" {
  description = "Sets the maximum number of background worker processes"
  type        = number
  default     = 3
}


variable "max_parallel_workers" {
  description = "Sets the maximum number of parallel worker  processes"
  type        = number
  default     = null
}

variable "max_logical_replication_workers" {
  description = "Sets the maximum number of simultaneously running logical replication workers"
  type        = number
  default     = null
}

variable "default_statistics_target" {
  description = "Sets the default statistics target"
  type        = number
  default     = 1000
}

variable "log_min_duration_statement" {
  description = "Sets the minimum execution time above which statements will be logged"
  type        = string
  default     = 100
}

variable "log_autovacuum_min_duration" {
  description = "Sets the minimum execution time above which autovacuum actions will be logged"
  type        = string
  default     = null
}

variable "log_checkpoints" {
  description = "Logs each checkpoint and its duration"
  type        = string
  default     = null
}

variable "log_connections" {
  description = "Logs each successful connection to the database"
  type        = string
#  default     = null
}

variable "log_line_prefix" {
  description = "Controls the information appended to each log line"
  type        = string
  default     = null
}

variable "log_lock_waits" {
  description = "Logs long lock waits"
  type        = string
  default     = null
}

variable "log_temp_files" {
  description = "Logs the use of temporary files larger than this number of kilobytes"
  type        = number
  default     = 0
}

variable "autovacuum_max_workers" {
  description = "Sets the maximum number of simultaneously running autovacuum worker processes"
  type        = number
  default     = 10
}

variable "autovacuum_vacuum_scale_factor" {
  description = "Specifies a fraction of the table size to add to the autovacuum target"
  type        = number
  default     = 0.1
}

variable "autovacuum_analyze_scale_factor" {
  description = "Specifies a fraction of the table size to add to the autovacuum target"
  type        = number
  default     = 0.05
}

variable "idle_in_transaction_session_timeout" {
  description = "Specifies a fraction of the table size to add to the autovacuum target"
  type        = number
  default     = 86400000
}

variable "cloudsql_logical_decoding" {
  description = "Sets Wal level to logical"
  type        = bool
  default     = true
}

variable "autovacuum_vacuum_cost_delay" {
  description = "Specifies the cost limit value that determines the point at which the cost-based vacuuming will be used"
  type        = string  
  default     = null
}

variable "track_commit_timestamp" {
  description = "Enables the collection of commit timestamps by the PostgreSQL server"
  type        = string
  default     = null
}

variable "pg_cron" {
  description = "pg_cron extension"
  type        = string
  default     = null
}


variable "postgresql_username" {
  type        = string
  default     = "postgres"
  description = "The username for the PostgreSQL user on the primary instance"
}

variable "postgresql_password" {
  type        = string
  sensitive   = true
  default     = ""
  description = "The password for the PostgreSQL user on the primary instance"
}

variable "postgresql_database" {
  type        = string
  default     = "postgres"
  description = "The name of the PostgreSQL database that you want to replicate to the standby instance"
}

variable "replication_slot_name" {
  type        = string
  default     = "primary_replication_slot"
  description = "The name of the replication slot on the primary instance"
}

variable "db_user_name" {
  type        = string
  default     = "my_test_app"
  description = "The username for app user"
}


variable "db_user_password" {
  type        = string
  default     = null
  description = "The password for app user"
}

variable "replica_count" {
  type        = number
#  default     = 0
  description = "The replica count for the cluster"
}

variable "disk_size" {
  description = "Amount of storage for the database instance in GB"
  type        = number
  default     = 100
}

variable "master_instance_name" {
  description = "The name of the primary instance to replicate from."
  type        = string
  default     = null
}
