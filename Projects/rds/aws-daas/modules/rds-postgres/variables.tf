variable "app_name" {
  description = "Name for the RDS instances and SG related to this environment"
}

variable "route53_zone_name" {}
variable "cname" {
  default = null
}

variable "instance_type" {
  description = "Instance type to use for the RDS instances"
}

variable "admin_username" {
  description = "RDS MySQL admin username"
}

variable "admin_password" {
  description = "RDS MySQL admin password"
}

variable "local_replica_cnt" {
  description = "Number of read replicas for the primary cluster"
}

variable "local_subnet_group" {}

variable "size" {}

variable "lz_vpc_name" {}

variable "db_name" {}

variable "aws_region" {}

variable "engine" {
	default = "postgres"
}

variable "engine_version" {
}

variable "port" {}

variable "allocated_storage" {
	default = "30" # gigabytes
}

variable "max_allocated_storage" {
	default = "1000" # gigabytes
}

variable "storage_type" {
	default = "gp2"
}

variable "iops" {
	default = "0"
}

variable "apply_immediately" {
        default = false
}

variable "multi_az" {}

variable "publicly_accessible" {
	default = false
}

variable "storage_encrypted" {
	default = false
}

variable "performance_insights_enabled" {
    default = "true"
}

variable "skip_final_snapshot" {
	default = true
}

variable "backup_retention_period" {
	default = "7"
}

variable "maintenance_window" {
	default = "Tue:00:00-Tue:03:00"
}

variable "backup_window" { 
	default = "03:00-06:00"
}

variable "replicate_source_db" {
	default = ""
}

variable "account_id" {
	default = ""
}
variable "jira_tag" {
}
variable "service_tag" {
}
variable "owner_tag" {
}
variable "tenantteam_tag" {
        default = ""
}
variable "tenantservice_tag" {
        default = ""
}
variable "allow_major_version_upgrade" {
        default = false
}
variable "kms_key_id" {
        default = ""
}
