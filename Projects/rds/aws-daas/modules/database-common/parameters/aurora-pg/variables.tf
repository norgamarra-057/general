variable "db_paramgroup_parameters_map" {
  type = map
  default = {
	"aurora-postgres13-cluster"	= [
    	{ name = "log_filename",             value = "postgresql.log.%Y-%m-%d-%H", apply_method = "pending-reboot" },
    	{ name = "shared_preload_libraries", value = "pg_stat_statements,pglogical", apply_method = "pending-reboot" },
    	{ name = "max_worker_processes",     value = "30", apply_method = "pending-reboot" },
    	{ name = "max_connections",          value = "998", apply_method = "pending-reboot" },
    	{ name = "max_replication_slots",    value = "10", apply_method = "pending-reboot" },
    	{ name = "max_wal_senders",          value = "20", apply_method = "pending-reboot" },
    	{ name = "rds.logical_replication",  value = "1", apply_method = "pending-reboot" },
    	{ name = "max_logical_replication_workers",  value = "6", apply_method = "pending-reboot" },
    	{ name = "max_sync_workers_per_subscription", value = "3", apply_method = "pending-reboot" },
    	{ name = "log_min_duration_statement", value = "200", apply_method = "pending-reboot" },
    	{ name = "autovacuum_max_workers", value = "12", apply_method = "pending-reboot" },
    	{ name = "log_statement", value = "ddl", apply_method = "pending-reboot" },
# logging - useful for health checks, but causes write overhead, for temporal usage
#    	{ name = "log_error_verbosity", value = "default" },
#    	{ name = "rds.force_autovacuum_logging", value = "log" },
#    	{ name = "log_autovacuum_min_duration", value = "1000" },
#    	{ name = "log_temp_files", value = "1000" },
#    	{ name = "log_lock_waits", value = "on" },
#    	{ name = "log_connections", value = "on" },
#    	{ name = "log_disconnects", value = "on" },
	],
	"aurora-postgres13-instance"	= [
    	{ name = "log_filename",             value = "postgresql.log.%Y-%m-%d-%H", apply_method = "pending-reboot" },
    	{ name = "shared_preload_libraries", value = "pg_stat_statements,pglogical", apply_method = "pending-reboot" },
    	{ name = "max_worker_processes",     value = "30", apply_method = "pending-reboot" },
    	{ name = "max_connections",          value = "998", apply_method = "pending-reboot" },
    	{ name = "max_replication_slots",    value = "10", apply_method = "pending-reboot" },
    	{ name = "max_wal_senders",          value = "20", apply_method = "pending-reboot" },
    	{ name = "rds.logical_replication",  value = "1", apply_method = "pending-reboot" },
    	{ name = "max_logical_replication_workers",  value = "6", apply_method = "pending-reboot" },
    	{ name = "max_sync_workers_per_subscription", value = "3", apply_method = "pending-reboot" },
    	{ name = "log_min_duration_statement", value = "200", apply_method = "pending-reboot" },
    	{ name = "autovacuum_max_workers",   value = "12", apply_method = "pending-reboot" },
    	{ name = "log_statement",            value = "ddl", apply_method = "pending-reboot" },
	],
  }
}

variable "db_parameter_family" {
}

