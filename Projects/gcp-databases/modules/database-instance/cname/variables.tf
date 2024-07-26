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

variable "dns_managed_zone" {
  description = "DNS Managed Zone for this VPC"
  type        = string
}

variable "db_cname" {
  description = "DB name to be used in the CNAME DNS record"
  type        = string
}

variable "cnames" {
  type = list(object({
    db_access_type = string
    aws_backend = string
    gcp_backend = string
    aws_weight = number
    gcp_weight = number
  }))
}