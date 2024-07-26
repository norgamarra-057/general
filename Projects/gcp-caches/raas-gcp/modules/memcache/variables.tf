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

variable "memcache_version" {
  type    = string
  default = "MEMCACHE_1_6_15"
}

variable "memory_size" {
  description = "Cache memory size in MB."
  type = number
  default = 1024
}
variable "node_count" {
  description = "Number of nodes in the memcache instance."
  type = number
  default = 1
}

variable "cpu_count" {
  description = "Number of CPUs per node."
  type = number
  default = 1
}

variable "labels" {
  description = "Labels to use for different tagging purposes"
  type = map(string)
}

variable "dns_name_dev" {
  description = "DNS name for dev environment"
  type        = string
  default     = "us-central1.caches.dev.gcp.groupondev.com."
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