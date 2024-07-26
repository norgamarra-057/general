variable "conf_postgres" {
  default = {
    "engine"                   = "postgres"
    "engine_version"           = "9.6"
    "port"                     = "5432"
    "identifier"               = "master"
    "allocated_storage"        = "50" # gigabytes
    "storage_type"             = "gp2"
    "multi_az"                 = false
    "publicly_accessible"      = true
    "storage_encrypted"        = false # you should always do this
    "skip_final_snapshot"      = true
    "backup_retention_period"  = "4"
    "maintenance_window"       = "Tue:00:00-Tue:03:00"
    "backup_window"            = "03:00-06:00"
    "database_name"            = ""
    }
}


# ==========================================================

variable "instance_name" {
  description = "Name for the RDS instances and SG related to this environment"
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

variable "remote_replica" {
  description = "Determines if a remote Aurora replica cluster should be created "
}

variable "local_replica_cnt" {
  description = "Number of read replicas for the primary cluster"
}

variable "primary_region" {
  description = "AWS region where the primary cluster will be created"
}
variable "remote_region" {
  description = "AWS region where the cross-region cluster will be created"
}

variable "local_subnet_group" {}

variable "remote_subnet_group" {}

variable "size" {}
