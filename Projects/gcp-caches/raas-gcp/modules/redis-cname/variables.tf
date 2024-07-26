variable "gcp_project_id" {
  description = "GCP project id where resources will be applied."
}

variable "gcp_region" {
  description = "GCP region where resources will be applied."
  type        = string
  default     = "us-central1"
}

variable "managed_zone_stable" {
  description = "DNS name for prod environment"
  type        = string
  default     = "dz-stable-sharedvpc01-us-central1-caches-stable"
}

variable "managed_zone_prod" {
  description = "DNS name for prod environment"
  type        = string
  default     = "dz-prod-sharedvpc01-us-central1-caches-prod"
}

variable "environment" {
  description = "Stable or Prod"
  type = string
  default = "stable"
}

variable "cache_cname" {
  description = "Cache name to be used in the CNAME DNS record"
  type        = string
}

variable "cnames" {
  type = list(object({
    aws_backend = string
    gcp_backend = string
    aws_weight = number
    gcp_weight = number
  }))
}