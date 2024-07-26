locals {
  engine = "memcached"
}

module lz {
  source      = "git::https://github.groupondev.com/production-fabric/AWSLandingZone.git//terraform/modules/landing_zone_data/?ref=f001b88"
  lz_vpc_name = var.lz_vpc_name
  I_PROMISE_I_WILL_NEVER_CHEAT_AND_MANUALLY_EXECUTE_TERRAFORM = "DATA-6874"
}

############################
# GET CONVEYOR CIDR BLOCKS
############################
data "aws_subnet_ids" "conveyor_subnet_ids" {
  vpc_id = module.lz.vpc_id
  tags = {
    Tier = "Conveyor"
  }
}
// In a loop, query the details for every Conveyor subnet.
data "aws_subnet" "conveyor_subnets" {
  count  = length(data.aws_subnet_ids.conveyor_subnet_ids.ids)
  vpc_id = module.lz.vpc_id
  filter {
    name   = "subnet-id"
    values = [sort(data.aws_subnet_ids.conveyor_subnet_ids.ids)[count.index]]
  }
}
locals {
  conveyor_cidr_blocks = data.aws_subnet.conveyor_subnets.*.cidr_block
}


resource "aws_security_group" "raas_memcached_conveyor" {
  name   = "raas_memcached_conveyor_${var.env}"
  vpc_id    = module.lz.vpc_id
  ingress {
    from_port       = "11211"                    # Memcache
    to_port         = "11211"
    protocol        = "tcp"
    cidr_blocks = concat(
      local.conveyor_cidr_blocks,
      [
        "10.224.14.0/27",
        "10.224.14.32/27",
        "10.224.14.64/27",
        "10.216.14.0/27",
        "10.216.14.64/27",
        "10.233.14.0/27",
        "10.233.14.32/27",
        "10.233.14.64/27",
        "10.183.0.0/21",
        "10.182.0.0/21",
        "10.190.0.0/21",
        "10.182.8.0/22",
        "10.183.8.0/22",
      ]
    )
  }
  # allow all:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Service = var.bbprovider
    Owner   = "raas-team@groupon.com"
  }
}

# the values are specified in vpc.tfvars for redis only (so far),
# so these variable definitions prevent the Warning: Value for undeclared variable
variable "create-sg-to-allow-conveyor-in-other-region" {
  type = bool
  default = false
}
variable "raas-allow-conveyor-in-other-region-subnets" {
  type = list
  default = []
}
variable "cloud-jenkins-subnets" {
  type = list
  default = []
}

###############################
# Allow Onprem (DATA-7042)
# special security to allow:
# - VPN to EC-dev and EC-staging
# - onprem to EC-prod
###############################

#e.g. ["10.20.0.0/14", "10.24.0.0/15", "10.32.0.0/14"] # SNC1 and SAC1:
variable "raas-allow-onprem" {
  type = list
  default = []
}

resource "aws_security_group" "raas_memcached_allow_onprem" {
  name   = "raas_memcached_allow_onprem_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "11211" # memcached
    to_port   = "11211"
    protocol  = "tcp"

    cidr_blocks = var.raas-allow-onprem
  }

  # allow all:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Service = var.bbprovider
    Owner   = "raas-team@groupon.com"
    Ticket  = "DATA-7042"
  }
}

resource "aws_elasticache_subnet_group" "raas-memcached-cross-az" {
  name       = "raas-memcached-cross-az-${var.env}"
  subnet_ids = module.lz.app_subnet_ids
}

data "aws_route53_zone" "stable" {
  name         = var.route53_zone_name
  private_zone = true
}

###############################
# SNS (DATA-6852)
###############################
resource "aws_sns_topic" "elasticache_events" {
  name = "raas-elasticache-memcached-events-${var.env}"
  tags = {
    Service = var.bbprovider
    Owner   = "raas-team@groupon.com"
  }
}


######################
# LEGACY
######################
# AZ=b:
resource "aws_elasticache_subnet_group" "raas-memcached-b" {
  count      = var.legacy_subnets ? 1 : 0
  name       = "raas-memcached-b-${var.env}"
  subnet_ids = [var.subnetid_b]
}
# cross-az:
resource "aws_elasticache_subnet_group" "raas-memcached-abc" {
  count      = var.legacy_subnets ? 1 : 0
  name       = "raas-memcached-abc-${var.env}"
  subnet_ids = module.lz.app_subnet_ids
}
