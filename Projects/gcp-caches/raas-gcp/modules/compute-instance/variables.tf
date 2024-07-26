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

variable "vm_name" {
  description = "This name will be used for connections and is the main cache name."
  type        = string
}

variable "machine_type" {
  description = "Instance type for VM"
  type = string
}

variable "subnetwork_us_prod" {
  description = "US private subnet"
  default = "sub-vpc-prod-sharedvpc01-us-central1-private"
}

variable "subnetwork_emea_prod" {
  description = "EMEA private subnet"
  default = "sub-vpc-prod-sharedvpc01-europe-west1-private"
}

locals {
  gcp_region = substr(var.zone, 0, length(var.zone) - 2)
  subnetwork = var.gcp_region == "us-central1" ? var.subnetwork_us_prod :var.gcp_region == "europe-west1" ? var.subnetwork_emea_prod :""
}

variable "zone" {
  description = "Zone for the instance"
  type        = string
}

variable "network_project" {
  description = "Project ID where the VPC network is located"
  default     = "prj-grp-shared-vpc-prod"
}
