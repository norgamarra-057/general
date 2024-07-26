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

variable "cache_display_name" {
  description = "Used for display in the console.  Optional."
  type        = string
  default     = ""
}

variable "cache_name" {
  description = "This name will be used for connections and is the main cache name."
  type        = string
}

variable "environment" {
  description = "Stable or Prod"
  type = string
  default = "stable"
}

variable "redis_version" {
  type    = string
  default = "REDIS_7_0"
}

variable "memory_size" {
  description = "Cache memory size in GB."
  type = number
}

variable "service_tier" {
  type    = string
  default = "BASIC"
}

variable "replica_count" {
  type = number
  description = "Number of read replicas"
  default     = 0
}

locals {
  use_replica = var.service_tier != "BASIC" ? true : false
}

variable "read_replicas_mode" {
  default = "READ_REPLICAS_DISABLED"
}

variable "labels" {
  description = "Labels to use for different tagging purposes"
  type = map(string)
}

variable "dns_name_stable" {
  description = "DNS name for stable environment"
  type        = string
  default     = "us-central1.caches.stable.gcp.groupondev.com."
}

variable "dns_name_prod" {
  description = "DNS name for prod environment"
  type        = string
  default     = "us-central1.caches.prod.gcp.groupondev.com."
}

variable "oom_warn_threshold_instance" {
  type = number
  description = "OOM Warning Threshold value in percent. Will trigger Warning Notification Channel."
}

variable "oom_critical_threshold_instance" {
  type = number
  description = "OOM Critical Threshold value in percent. Will trigger Critical Notification Channel."
}

variable "cpu_warn_threshold_instance" {
  type = number
  description = "CPU Warning Threshold value in percent. Will trigger Warning Notification Channel."
}

variable "cpu_critical_threshold_instance" {
  type = number
  description = "CPU Critical Threshold value in percent. Will trigger Critical Notification Channel."
}

variable "max_connect_warn_threshold_instance" {
  type = number
  description = "Max Connections Warning Threshold value in percent. Will trigger Warning Notification Channel."
}

variable "max_connect_critical_threshold_instance" {
  type = number
  description = "Max Connections Critical Threshold value in percent. Will trigger Critical Notification Channel."
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