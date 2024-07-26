variable "region_to_subnets_map" {
  type = "map"
  default = {
    us-west-1    = ["subnet-043d0ea85ff9bf10e", "subnet-09c699f46d7f3898e"]
    eu-west-1    = ["subnet-052db34d", "subnet-28b6384e","subnet-48498112"]
  }
}

variable "region_to_vpcid_map" {
  type = "map"
  default = {
    us-west-1    = "vpc-0a38df8f4ac2b624c"
    eu-west-1    = "vpc-55adfd33"
  }
}

