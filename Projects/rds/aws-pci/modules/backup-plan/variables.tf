variable "aws_region" {
  description = "Which AWS region the instance is in"
}

variable "account_id" {
  description = "AWS account id as defined in account-level.tfvars"
  default     = null
}

variable "role_id" {
  description = "AWS role_id for KMS as defined in region-level.tfvars"
  default     = null
}

variable "route53_zone_name" {
  description = "AWS zone name for aurora-mysql as defined in region-level.tfvars"
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

variable "cross_account_id" {
  description = "AWS cross_account_id for KMS as defined in region-level.tfvars"
  default     = null
}

variable "aws_region_sec" {
  description = "AWS aws_region_sec for Security as defined in region-level.tfvars"
  default     = null
}

variable "lz_vpc_name" {
  description = "AWS alz_vpc_name for Networking as defined in region-level.tfvars"
  default     = null
}

variable "backup_vault" {}

variable "backup_plan_name" {}

variable "backup_cron" {}

#variable "cold_storage_after" {}

#variable "delete_after" {}

variable "tag_key" {}

variable "tag_value" {}

variable "resources_list" {
  type = list
}

variable "lc_options" {
  type = list
}
