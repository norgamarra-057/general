variable "apply_immediately" {
  description = "Used for Aurora minor upgrades"
  default     = "false"
}

variable "route53_zone_name" {}

variable "cname" {
  default = null
}

variable "admin_username" {
  description = "RDS MySQL admin username"
  default = "gds_admin"
}

variable "admin_password" {
  description = "RDS MySQL admin password"
  default     = "Gr0up0n!$KaL3$"
}

variable "app_name" {
  description = "Name for the RDS instances and SG related to this environment"
}

variable "instance_type" {
  description = "Instance type to use for the RDS instances"
}

variable "local_replica_cnt" {
  description = "Number of read replicas for the primary cluster"
}

variable "local_subnet_group" {}

variable "size" {}

variable "lz_vpc_name" {}

variable "cluster_master_arn" {
    default = ""
}

variable "kms_key_id" {
    default = ""
}

variable "engine" {}

variable "engine_version" {}

variable "db_name" {}

variable "multi_az" {}

variable "port" {}

variable "account_id" {
    default = ""
}

variable "source_region" {
    default = ""
}

variable "backup_retention_period" {
    default = "7"
}

variable "storage_encrypted" {
    default = "false"
}

variable "preferred_backup_window" {
    default = ""
}
variable "performance_insights_enabled" {
    default = "true"
}
variable "enabled_cloudwatch_logs_exports" {
    default = ["slowquery"]
    type = list
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
