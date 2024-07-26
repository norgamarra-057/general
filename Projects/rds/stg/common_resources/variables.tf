variable "region_to_subnets_map" {
  type = "map"
  default = {
    us-west-1    = ["subnet-05f9a3c51c74eaf5d", "subnet-0087815eb1ab25350"]
    us-west-2    = ["subnet-0299d44de70ab9202", "subnet-0d56223cb04f96cbe"]
    eu-west-1    = ["subnet-0b2facab9550732e0", "subnet-0b7bd2cdc0ce1c229"]
  }
}

variable "region_to_vpcid_map" {
  type = "map"
  default = {
    us-west-1    = "vpc-0b9646d4d3056cc8f"
    us-west-2    = "vpc-04623c539ffa5f17e"
    eu-west-1    = "vpc-8b277aed"
  }
}

