variable "service_tag" {
  default = ""
}

variable "owner_tag" {
  default = ""
}

variable "tenantteam_tag" {
  default = ""
}

variable "account_id" {
  default = ""
}

variable "aws_region_sec" {
  description = "Used by Security module"
  default = null
}

variable "cross_account_id" {
  default = ""
}

variable "role_id" {
  default = ""
}

variable "secret_name" {
  default = "gds_main_account"
}

# Unused variables for this module, but declaring them to remove the warnings
variable "lz_vpc_name" {
  default = ""
}

variable "lz_vpc_sec_name" {
  default = ""
}

variable "route53_zone_name" {
  default = ""
}

variable "admin_username" {
  default = ""
}

variable "admin_password" {
  default = ""
}
