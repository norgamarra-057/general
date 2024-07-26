variable "gcp_project_id" {
  description = "GCP project id where resources will be applied."
}

variable "gcp_region" {
  description = "GCP region where resources will be applied."
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "VPC that the cache will use for networking."
  type        = string
}

variable "vpc_project_id" {
  description = "Project where the VPC resides.  Note that this is not necessarily the same as the cache project."
  type        = string
}

variable "environment" {
  description = "Stable or Prod"
  type = string
  default = "stable"
}

variable "labels" {
  description = "Labels to use for different tagging purposes"
  type = map(string)
}

variable "oom_warn_threshold_memcache" {
  type = number
  description = "OOM Warning Threshold value in percent. Will trigger Warning Notification Channel."
}

variable "oom_critical_threshold_memcache" {
  type = number
  description = "OOM Critical Threshold value in percent. Will trigger Critical Notification Channel."
}

variable "cpu_warn_threshold_memcache" {
  type = number
  description = "CPU Warning Threshold value in percent. Will trigger Warning Notification Channel."
}

variable "cpu_critical_threshold_memcache" {
  type = number
  description = "CPU Critical Threshold value in percent. Will trigger Critical Notification Channel."
}

variable "max_connect_warn_threshold_memcache" {
  type = number
  description = "Max Connections Warning Threshold value in percent. Will trigger Warning Notification Channel."
}

variable "max_connect_critical_threshold_memcache" {
  type = number
  description = "Max Connections Critical Threshold value in percent. Will trigger Critical Notification Channel."
}

variable "managed_zone_dev" {
  description = "DNS name for prod environment"
  type        = string
  default     = "dz-stable-sharedvpc01-us-central1-caches-dev"
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

variable "oom_exclusion_list" {
  description = "List of instances to exclude from OOM alerts"
  type        = list(string)
}

variable "cpu_exclusion_list" {
  description = "List of instances to exclude from OOM alerts"
  type        = list(string)
}

variable "max_cons_exclusion_list" {
  description = "List of instances to exclude from OOM alerts"
  type        = list(string)
}