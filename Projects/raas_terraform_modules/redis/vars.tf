variable "aws_region" {
  description = "Which AWS region the instance is in"
}

variable "env" {
  description = "Environment: dev, staging, production"
}

variable "group" {
  description = "Subdivision inside an env in a region, example: im, rm, watson"
  default     = "gen"
}

variable "bbprovider" {
  description = "building block provider, e.g. raas"
}

variable "lz_vpc_name" {
  description = "The value of the Name tag for the Landing Zone VPC"
  type        = string
}

variable "route53_zone_name" {
  description = "e.g. stable.us-west-2.aws.groupondev.com."
}

######################
# LEGACY
######################
variable "subnetid_b" {
  description = "Subnet ID for AZ b"
  default     = "n/a"
}
variable "legacy_subnets" {
  default     = false
}
