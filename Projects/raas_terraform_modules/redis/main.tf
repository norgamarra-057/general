locals {
  engine = "redis"
}

module lz {
  source      = "git::https://github.groupondev.com/production-fabric/AWSLandingZone.git//terraform/modules/landing_zone_data/?ref=75a254a"
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


variable "cloud-jenkins-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_redis_conveyor" {
  name   = "raas_redis_conveyor_${var.env}"
  vpc_id    = module.lz.vpc_id
  ingress {
    from_port       = "6379"                    # Redis
    to_port         = "6379"
    protocol        = "tcp"
cidr_blocks = concat(
  local.conveyor_cidr_blocks,
  var.cloud-jenkins-subnets,
  [
    "10.182.8.0/22",
    "10.183.8.0/22",
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
    "10.190.0.0/21"
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

resource "aws_security_group_rule" "cidr_conveyor_gcp_stable" {
  type              = "ingress"
  from_port         = "6379"	
  to_port           = "6379"
  protocol          = "tcp"
  cidr_blocks       = ["10.182.8.0/22"]
  security_group_id = "sg-0a05ce69810348368"
}

resource "aws_elasticache_subnet_group" "raas-redis-cross-az" {
  name       = "raas-redis-cross-az-${var.env}"
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
  name = "raas-elasticache-redis-events-${var.env}"
  tags = {
    Service = var.bbprovider
    Owner   = "raas-team@groupon.com"
  }
}

################################################
# RAAS-712: allow GCP
################################################

variable "create-sg-to-allow-gcp" {
  type = bool
  default = false
}

variable "raas-gcp-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_allow_gcp_sg" {
  count  = var.create-sg-to-allow-gcp ? 1 : 0
  name   = "raas_allow_gcp_sg_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
    protocol  = "tcp"
    cidr_blocks = var.raas-gcp-subnets
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
    Ticket  = "RAAS-712"
  }
}

################################################
# Allow DND AWS account (RAAS-432)
################################################

variable "create-sg-to-allow-dnd-account" {
  type = bool
  default = false
}

variable "raas-dnd-account-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_allow_dnd_account_sg" {
  count  = var.create-sg-to-allow-dnd-account ? 1 : 0
  name   = "raas_allow_dnd_account_sg_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
    protocol  = "tcp"
    cidr_blocks = var.raas-dnd-account-subnets
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
    Ticket  = "RAAS-432"
  }
}

################################################
# Allow EMR AWS account (RAAS-112)
################################################

variable "create-sg-to-allow-emr-account" {
  type = bool
  default = false
}

variable "raas-emr-account-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_allow_emr_account_sg" {
  count  = var.create-sg-to-allow-emr-account ? 1 : 0
  name   = "raas_allow_emr_account_sg_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
    protocol  = "tcp"
    cidr_blocks = var.raas-emr-account-subnets
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
    Ticket  = "RAAS-112"
  }
}


################################################
# Allow Vouchercloud AWS account (RAAS-243)
################################################

variable "create-sg-to-allow-voucher-account" {
  type = bool
  default = false
}

variable "raas-voucher-account-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_allow_voucher_account_sg" {
  count  = var.create-sg-to-allow-voucher-account ? 1 : 0
  name   = "raas_allow_voucher_account_sg_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
    protocol  = "tcp"
    cidr_blocks = var.raas-voucher-account-subnets
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
    Ticket  = "RAAS-243"
  }
}

################################################
# Allow conveyor in the other region (RAAS-244)
################################################

variable "create-sg-to-allow-conveyor-in-other-region" {
  type = bool
  default = false
}

variable "raas-allow-conveyor-in-other-region-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_allow_conveyor_in_other_region_sg" {
  count  = var.create-sg-to-allow-conveyor-in-other-region ? 1 : 0
  name   = "raas_allow_conveyor_in_other_region_sg_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
    protocol  = "tcp"
    cidr_blocks = var.raas-allow-conveyor-in-other-region-subnets
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
    Ticket  = "RAAS-244"
  }
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

resource "aws_security_group" "raas_redis_allow_onprem" {
  name   = "raas_redis_allow_onprem_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
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

###############################
# Allow ConveyorGCP (RAAS-1093)
# special security to allow:
# - GCP to AWS
###############################

variable "create-sg-to-allow-conveyor-gcp" {
  type = bool
  default = false
}

variable "raas-conveyor-gcp-subnets" {
  type = list
  default = []
}

resource "aws_security_group" "raas_allow_conveyor_gcp_sg" {
  count  = var.create-sg-to-allow-conveyor-gcp ? 1 : 0
  name   = "raas_allow_conveyor_gcp_${var.env}"
  vpc_id = module.lz.vpc_id

  ingress {
    from_port = "6379" # Redis
    to_port   = "6379"
    protocol  = "tcp"
    cidr_blocks = var.raas-conveyor-gcp-subnets
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
    Ticket  = "RAAS-RAAS-1093"
  }
}

############################################
# RaaS Parameter Groups (DATA-7266, RAAS-99)
############################################

resource "aws_elasticache_parameter_group" "raas-redis6-allkeys-lru" {
  name   = "raas-redis6-allkeys-lru"
  family = "redis6.x"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

resource "aws_elasticache_parameter_group" "raas-redis5-allkeys-lfu" {
  name   = "raas-redis5-allkeys-lfu"
  family = "redis5.0"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lfu"
  }
}

resource "aws_elasticache_parameter_group" "raas-redis5-allkeys-lru" {
  name   = "raas-redis5-allkeys-lru"
  family = "redis5.0"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

resource "aws_elasticache_parameter_group" "raas-redis5-cluster-allkeys-lru" {
  name   = "raas-redis5-cluster-allkeys-lru"
  family = "redis5.0"

  parameter {
    name  = "cluster-enabled"
    value = "yes"
  }
  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}

######################
# LEGACY
######################
# AZ=b:
resource "aws_elasticache_subnet_group" "raas-redis-b" {
  count      = var.legacy_subnets ? 1 : 0
  name       = "raas-redis-b-${var.env}"
  subnet_ids = [var.subnetid_b]
}
# cross-az:
resource "aws_elasticache_subnet_group" "raas-redis-abc" {
  count      = var.legacy_subnets ? 1 : 0
  name       = "raas-redis-abc-${var.env}"
  subnet_ids = module.lz.app_subnet_ids
}
