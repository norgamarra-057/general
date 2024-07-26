variable "db_paramgroup_parameters_map" {
  type = map
  default = {
	"aurora-mysql5.7-cluster"	= [
    	{ name = "binlog_format",                   value = "ROW" },
    	{ name = "log_bin_trust_function_creators", value = "1", apply_method = "pending-reboot" },
    	{ name = "innodb_autoinc_lock_mode",        value = "2", apply_method = "pending-reboot" },
    	{ name = "max_connections",                 value = "998" },
    	{ name = "character_set_database",          value = "utf8" },
	],
	"aurora-mysql5.7-instance"	= [
    	{ name = "binlog_format",                   value = "ROW" },
    	{ name = "log_bin_trust_function_creators", value = "1", apply_method = "pending-reboot" },
    	{ name = "max_connections",                 value = "998" },
	],
	"aurora5.6-cluster"	= [
    	{ name = "log_bin_trust_function_creators", value = "1" },
    	{ name = "innodb_autoinc_lock_mode",        value = "2", apply_method = "pending-reboot" },
    	{ name = "max_connections",                 value = "8000" },
    	{ name = "max_user_connections",            value = "7980" },
    	{ name = "character_set_database",          value = "utf8" },
	],
	"aurora5.6-instance"	= [
    	{ name = "log_bin_trust_function_creators", value = "1" },
    	{ name = "innodb_autoinc_lock_mode",        value = "2", apply_method = "pending-reboot" },
    	{ name = "max_user_connections",            value = "7980" },
	],
  }
}

variable "db_parameter_family" {
}

