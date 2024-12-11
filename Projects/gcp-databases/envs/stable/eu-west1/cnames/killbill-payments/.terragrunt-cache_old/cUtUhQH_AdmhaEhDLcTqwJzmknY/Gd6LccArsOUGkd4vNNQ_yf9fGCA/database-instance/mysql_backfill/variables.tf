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

variable "db_instance_name" {
  description = "The name of the database instance."
  type        = string
}

#variable "db_replica_name" {
#  description = "The name of the replica DB instance."
#  type        = string
#}

variable "replica_count" {
  type        = number
#  default     = 0
  description = "The replica count for the cluster"
}

variable "db_version" {
  description = "The engine version to use for the database."
  type        = string
}

variable "db_tier" {
  description = "The tiering or size for the database."
  type        = string
}

variable "db_type" {
  description = "The type of database (mysql or postgres)"
  type        = string
  default     = "mysql"  # Set the default type to MySQL
}

variable "backup_configuration_enabled" {
  description = "Enable backup configuration"
  type        = bool
  default     = true
}

#variable "replication_enabled" {
#  description = "Enable replication"
#  type        = bool
#  default     = true
# }

#variable "memory" {
#  description = "Amount of memory for the database instance"
#  type        = string
#  default     = "1GB"
#}

#variable "cpu" {
#  description = "Number of CPUs for the database instance"
#  type        = string
#  default     = "1"
# }

variable "disk_size" {
  description = "Amount of storage for the database instance in GB"
  type        = number
  default     = 100
}

variable "max_connections" {
  description = "setting the max_connections variable value"
  type        = number
  default     = 1000
}

variable "max_allowed_packet" {
  type    = number
  default = 1048576
}

variable "long_query_time" {
  description = "Enabling long query time"
  type        = number
  default     = 1
}

variable "log_output" {
  description = "Enabling the slow queries log"
  type        = string
  default     = "FILE"
}

variable "character_set_server" {
  type    = string
  default = "utf8"
}

variable "character_set_client" {
  type    = string
  default = "utf8mb4"
}

variable "character_set_connection" {
  type    = string
  default = "utf8mb4"
}

variable "character_set_results" {
  type    = string
  default = "utf8mb4"
}

#variable "explicit_defaults_for_timestamp" {
#  description = "setting the explicit_defaults_for_timestamp variable value"
#  type        = bool
#  default     = "true"
#}

# variable "log_bin_trust_function_creators" {
#  description = "setting the max_connections variable value"
#  type        = bool
#  default     = "true"
#}

variable "wait_timeout" {
  description = "setting the wait_timeout variable value"
  type        = number
  default     = null
}

variable "general_log" {
  description = "enabling the general log"
  type        = string
  default     = "FILE"
}

variable "jira_tag" {
    default = ""
}

variable "service_tag" {
    default = ""
}

variable "owner_tag" {
    default = ""
}

variable "tenantteam_tag" {
    default = ""
}

variable "tenantservice_tag" {
    default = ""
}

variable "admin_username" {
  description = "MySQL admin username"
  default = "gds_admin"
}

variable "admin_password" {
  description = "MySQL admin password"
  default     = "Gr0up0n!$KaL3$"
}
