locals {
    admin_username       = lookup(jsondecode(data.aws_secretsmanager_secret_version.gds_secret.secret_string),"username")
    admin_password       = lookup(jsondecode(data.aws_secretsmanager_secret_version.gds_secret.secret_string),"password")
}

data "aws_secretsmanager_secret_version" "gds_secret" {
    secret_id = var.secret_name
}

variable "secret_name" {
    default = "gds_main_account"
}

variable "apply_immediately" {
    description = "Used for Aurora minor upgrades"
    default     = "false"
}

variable "aws_region" {
    description = "Which AWS region the instance is in"
}

variable "route53_zone_name" {}

variable "cname" {
    default = null
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

variable "lz_vpc_name" {
    description = "Default VPC that instance uses"
    default = "MainVPC"
}

variable "aws_region_sec" {
    description = "Used by Security module"
    default = null
}

variable "cross_account_id" {
    description = "Used by KMS module"
    default = null
}

variable "role_id" {
    description = "Used by KMS module"
    default = null
}

variable "local_subnet_group" {
    description = "Default DB Subnet Group"
    default = "sgroup-1"
}

data "aws_security_group" "security_group" {
    filter {
        name   = "group-name"
        values = ["pci_gds_mysql_sg"]
    }
}

variable "cluster_master_arn" {
    default = ""
}

variable "kms_key_id" {
    default = ""
}

variable "size" {}

variable "engine" {}

variable "engine_version" {}

variable "db_name" {}

variable "multi_az" {}

variable "port" {
    default = 3306
}

variable "account_id" {
    default = ""
}

variable "source_region" {
    default = ""
}

variable "backup_retention_period" {
    default = "35"
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

variable "backup_tag" {
    default = "pci-gds-backup"
}

variable "jira_tag" {}

variable "service_tag" {}

variable "owner_tag" {}

variable "tenantteam_tag" {
    default = ""
}

variable "tenantservice_tag" {
    default = ""
}
