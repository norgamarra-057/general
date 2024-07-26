variable "instance_name" {
  description = "Name for the RDS instances and SG related to this environment"
}

variable "instance_type" {
  description = "Instance type to use for the RDS instances"
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
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

variable "remote_replica_cnt" {
  description = "Number of read replicas for the cross-region cluster"
}

variable "primary_region" {
  description = "AWS region where the primary cluster will be created"
}
variable "remote_region" {
  description = "AWS region where the cross-region cluster will be created"
}

variable "engine" {
  description = "RDS Aurora MySQL Engine"
}

variable "engine_version" {
  description = "RDS Aurora MySQL Engine version"
}
variable "local_subnet_group" {}

variable "remote_subnet_group" {}

variable "size" {}
