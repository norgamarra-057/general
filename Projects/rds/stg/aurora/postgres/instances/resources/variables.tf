variable "instance_name" {
  description = "Name for the RDS instances and SG related to this environment"
}

variable "instance_type" {
  description = "Instance type to use for the RDS instances"
}

variable "vpcid" {
  description = "AWS VPC ID where the SG will be created"
}

variable "vpcid_east1" {
  description = "AWS VPC ID where the SG will be created for east1"
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

variable "local_subnet_group" {}

variable "remote_subnet_group" {}


variable "size" {}
