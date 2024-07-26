variable "aurora_instance_type" {
  default = ""
  description = "Instance type to use for the RDS instances"
}

variable "aurora_replica_cnt" {
  default = 0
  description = "Number of read replicas for the primary cluster"
}

variable "aurora_engine" {
  default = "aurora-postgresql"
}
