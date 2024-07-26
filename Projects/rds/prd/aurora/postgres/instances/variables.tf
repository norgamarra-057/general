variable "workspace_to_environment_map" {
  type = "map"
  default = {
    gciciliani     = "gciciliani"
    users      = "users"
    pwa 	   = "pwa"
    dev 	   = "dev"
    payments   = "payments"
  }
}

variable "environment_to_insttype_map" {
  type = "map"
  default = {
    gciciliani     = "db.t2.small"
    users      = "db.t2.small"
    pwa 	   = "db.t2.small"
    dev 	   = "db.t2.small"
    payments   = "db.t2.small"
  }
}

variable "environment_to_primary_region_map" {
  type = "map"
  default = {
    gciciliani    = "us-west-1"
    users     = "us-west-2"
    pwa 	  = "us-west-1"
    dev 	  = "us-west-2"
    payments  = "us-west-1"
  }
}

variable "environment_to_remote_region_map" {
  type = "map"
  default = {
    gciciliani    = "us-west-2"
    users     = "us-west-1"
    pwa 	  = "us-west-2"
    dev 	  = "us-west-1"
    payments  = "us-west-2"
  }
}

variable "environment_to_size_map" {
  type = "map"
  default = {
    gciciliani    = "small"
    users     = "medium"
    pwa 	  = "large"
    dev 	  = "small"
    payments  = "medium"
  }
}

variable "region_to_vpcid_map" {
  type = "map"
  default = {
    us-west-1    = "vpc-0b9646d4d3056cc8f"
    us-west-2    = "vpc-04623c539ffa5f17e"
  }
}

variable "adminpassword" {}
