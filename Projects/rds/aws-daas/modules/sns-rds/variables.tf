variable "app_name" {
  description = "Name for the RDS instances and SG related to this environment"
}

variable "admin_username" {
  description = "RDS MySQL admin username"
}

variable "admin_password" {
  description = "RDS MySQL admin password"
}

variable "lz_vpc_name" {}

variable "lz_vpc_sec_name" {}

variable "aws_region" {}

variable "aws_region_sec" {}

variable "route53_zone_name" {}

variable "apply_immediately" {
    	default = false
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
