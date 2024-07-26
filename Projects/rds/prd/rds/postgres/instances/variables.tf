variable "workspace_to_environment_map" {
  type = "map"
  default = {
    gciciliani     = "gciciliani"
    valid1         = "valid1"
  }
}

variable "environment_to_insttype_map" {
  type = "map"
  default = {
    gciciliani     = "db.t2.small"
    valid1         = "db.r5.2xlarge"
  }
}

variable "environment_to_primary_region_map" {
  type = "map"
  default = {
    gciciliani    = "us-west-1"
    valid1        = "us-west-1"
  }
}

variable "environment_to_remote_region_map" {
  type = "map"
  default = {
    gciciliani    = "eu-west-1"
    valid1        = "eu-west-1"
  }
}

variable "environment_to_size_map" {
  type = "map"
  default = {
    gciciliani    = "small"
    valid1        = "large"
  }
}

variable "environment_to_dbname_map" {
  type = "map"
  default = {
    gciciliani    = "gcicilianidb"
    valid1        = "valid1"
  }
}

variable "adminpassword" {}


variable "environment_to_remote_replica_map" {
  type = "map"
  default = {
    gciciliani     = 1
    valid1         = 0
  }
}

variable "environment_to_local_replica_cnt_map" {
  type = "map"
  default = {
    gciciliani     = 1
    valid1         = 1
  }
}
