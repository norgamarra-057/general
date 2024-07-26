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

variable "channel_name" {
  description = "This name will be used for the notification channel."
  type        = string
}

variable "channel_type" {
  description = "This type will be used for the notification channel."
  type        = string
}

variable "channel_address" {
  description = "This address will be used for the notification channel."
  type        = string
}