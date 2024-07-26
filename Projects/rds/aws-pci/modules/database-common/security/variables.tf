variable "account_id" {
  description = "AWS account id as defined in account-level.tfvars"
  default     = null
}

variable "role_id" {
  description = "AWS role_id for KMS as defined in region-level.tfvars"
  default     = null
}

variable "cross_account_id" {
  description = "AWS cross_account_id for KMS as defined in region-level.tfvars"
  default     = null
}

variable "admin_username" {
  description = "AWS admin name for aurora-mysql as defined in module-specific.tfvars"
  default     = null
}

variable "admin_password" {
  description = "AWS admin password for aurora-mysql as defined in module-specific.tfvars"
  default     = null
}

variable "route53_zone_name" {
  description = "AWS zone name for aurora-mysql as defined in region-level.tfvars"
  default     = null
}

variable "aws_region" {
  description = "Which AWS region the instance is in"
  type        = string
}

variable "aws_region_sec" {
  description = "AWS aws_region_sec for Security as defined in region-level.tfvars"
  type        = string
  default     = null
}

variable "lz_vpc_name" {
  description = "The value of the Name tag for the VPC"
  default     = null
  type        = string
}
variable "lz_vpc_sec_name" {
  description = "The value of the Name tag for the secondary region VPC"
  default     = null
  type        = string
}
