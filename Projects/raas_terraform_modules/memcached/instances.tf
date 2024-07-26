
##########################
# test2
##########################
variable "memcached-test2" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "test2" {
  count                        = var.memcached-test2["create"] ? 1 : 0
  cluster_id                   = "test2-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-test2["node_type"]
  num_cache_nodes              = var.memcached-test2["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-test2["ticket"]
  }
}

resource "aws_route53_record" "test2_cname" {
  count   = var.memcached-test2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test2--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.test2[count.index].cluster_address]
}

##########################
# cluster-test1
##########################
variable "memcached-cluster-test1" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-cluster-test1-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "cluster-test1" {
  count                        = var.memcached-cluster-test1["create"] ? 1 : 0
  cluster_id                   = "cluster-test1-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-cluster-test1["node_type"]
  num_cache_nodes              = var.memcached-cluster-test1["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-cluster-test1-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-cluster-test1["ticket"]
  }
}

resource "aws_route53_record" "cluster-test1_cname" {
  count   = var.memcached-cluster-test1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "cluster-test1--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.cluster-test1[count.index].cluster_address]
}

##########################
# mfake
##########################
variable "memcached-mfake" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-mfake-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "mfake" {
  count                        = var.memcached-mfake["create"] ? 1 : 0
  cluster_id                   = "mfake-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-mfake["node_type"]
  num_cache_nodes              = var.memcached-mfake["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-mfake-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-mfake["ticket"]
  }
}

resource "aws_route53_record" "mfake_cname" {
  count   = var.memcached-mfake["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mfake--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.mfake[count.index].cluster_address]
}

##########################
# deckard
##########################
variable "memcached-deckard" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-deckard-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "deckard" {
  count                        = var.memcached-deckard["create"] ? 1 : 0
  cluster_id                   = "deckard-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-deckard["node_type"]
  num_cache_nodes              = var.memcached-deckard["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-deckard-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "deckard"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-deckard["ticket"]
  }
}

resource "aws_route53_record" "deckard_cname" {
  count   = var.memcached-deckard["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deckard--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.deckard[count.index].cluster_address]
}

##########################
# layout-svc
##########################
variable "memcached-layout-svc" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-layout-svc-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "layout-svc" {
  count                        = var.memcached-layout-svc["create"] ? 1 : 0
  cluster_id                   = "layout-svc-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-layout-svc["node_type"]
  num_cache_nodes              = var.memcached-layout-svc["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-layout-svc-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "layout-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-layout-svc["ticket"]
  }
}

resource "aws_route53_record" "layout-svc_cname" {
  count   = var.memcached-layout-svc["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "layout-service--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.layout-svc[count.index].cluster_address]
}

##########################
# occasions
##########################
variable "memcached-occasions" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-occasions-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "occasions" {
  count                        = var.memcached-occasions["create"] ? 1 : 0
  cluster_id                   = "occasions-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-occasions["node_type"]
  num_cache_nodes              = var.memcached-occasions["num_nodes"]
  subnet_group_name            = var.memcached-occasions["subnet_group_name"]    # legacy, prefer "raas-memcached-cross-az
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = var.memcached-occasions["az_mode"]              # legacy, should always be "cross-az"
  preferred_availability_zones = var.memcached-occasions-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "occasions"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-occasions["ticket"]
  }
}

resource "aws_route53_record" "occasions_cname" {
  count   = var.memcached-occasions["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "occasions--cache.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.occasions[count.index].cluster_address]
}
# first cname was created before the ".service" suffix standard
# cname2 allows new memcached instances to be compliant:
resource "aws_route53_record" "occasions_cname2" {
  count   = var.memcached-occasions["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "occasions--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.occasions[count.index].cluster_address]
}

##########################
# usr-sessions
##########################
variable "memcached-usr-sessions" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "usr-sessions" {
  count                        = var.memcached-usr-sessions["create"] ? 1 : 0
  cluster_id                   = "usr-sessions-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-usr-sessions["node_type"]
  num_cache_nodes              = var.memcached-usr-sessions["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "user_sessions"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-usr-sessions["ticket"]
  }
}

resource "aws_route53_record" "usr-sessions_cname" {
  count   = var.memcached-usr-sessions["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "user-sessions--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.usr-sessions[count.index].cluster_address]
}

##########################
# awx-a-agent1
##########################
variable "memcached-awx-a-agent1" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-a-agent1" {
  count                        = var.memcached-awx-a-agent1["create"] ? 1 : 0
  cluster_id                   = "awx-a-agent1-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-awx-a-agent1["node_type"]
  num_cache_nodes              = var.memcached-awx-a-agent1["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-a-agent1["ticket"]
  }
}

resource "aws_route53_record" "awx-a-agent1_cname" {
  count   = var.memcached-awx-a-agent1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-a-agent1--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-a-agent1[count.index].cluster_address]
}

##########################
# awx-a-agent2
##########################
variable "memcached-awx-a-agent2" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-a-agent2" {
  count                        = var.memcached-awx-a-agent2["create"] ? 1 : 0
  cluster_id                   = "awx-a-agent2-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-awx-a-agent2["node_type"]
  num_cache_nodes              = var.memcached-awx-a-agent2["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-a-agent2["ticket"]
  }
}

resource "aws_route53_record" "awx-a-agent2_cname" {
  count   = var.memcached-awx-a-agent2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-a-agent2--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-a-agent2[count.index].cluster_address]
}

##########################
# awx-b-agent1
##########################
variable "memcached-awx-b-agent1" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-b-agent1" {
  count                        = var.memcached-awx-b-agent1["create"] ? 1 : 0
  cluster_id                   = "awx-b-agent1-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-awx-b-agent1["node_type"]
  num_cache_nodes              = var.memcached-awx-b-agent1["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-b-agent1["ticket"]
  }
}

resource "aws_route53_record" "awx-b-agent1_cname" {
  count   = var.memcached-awx-b-agent1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-b-agent1--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-b-agent1[count.index].cluster_address]
}

##########################
# awx-b-agent2
##########################
variable "memcached-awx-b-agent2" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-b-agent2" {
  count                        = var.memcached-awx-b-agent2["create"] ? 1 : 0
  cluster_id                   = "awx-b-agent2-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-awx-b-agent2["node_type"]
  num_cache_nodes              = var.memcached-awx-b-agent2["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-b-agent2["ticket"]
  }
}

resource "aws_route53_record" "awx-b-agent2_cname" {
  count   = var.memcached-awx-b-agent2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-b-agent2--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-b-agent2[count.index].cluster_address]
}

##########################
# awx-a-infosec-agent1
##########################
variable "memcached-awx-a-infosec-agent1" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-a-infosec-agent1" {
  count                        = var.memcached-awx-a-infosec-agent1["create"] ? 1 : 0
  cluster_id                   = "awx-a-infosec-agent1-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-awx-a-infosec-agent1["node_type"]
  num_cache_nodes              = var.memcached-awx-a-infosec-agent1["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-a-infosec-agent1["ticket"]
  }
}

resource "aws_route53_record" "awx-a-infosec-agent1_cname" {
  count   = var.memcached-awx-a-infosec-agent1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-a-infosec-agent1--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-a-infosec-agent1[count.index].cluster_address]
}

##########################
# awx-a-infosec-agent2
##########################
variable "memcached-awx-a-infosec-agent2" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-a-infosec-agent2" {
  count                        = var.memcached-awx-a-infosec-agent2["create"] ? 1 : 0
  cluster_id                   = "awx-a-infosec-agent2-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-awx-a-infosec-agent2["node_type"]
  num_cache_nodes              = var.memcached-awx-a-infosec-agent2["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-a-infosec-agent2["ticket"]
  }
}

resource "aws_route53_record" "awx-a-infosec-agent2_cname" {
  count   = var.memcached-awx-a-infosec-agent2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-a-infosec-agent2--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-a-infosec-agent2[count.index].cluster_address]
}

##########################
# awx-a-metrics-agent1
##########################
variable "memcached-awx-a-metrics-agent1" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-a-metrics-agent1" {
  count                        = var.memcached-awx-a-metrics-agent1["create"] ? 1 : 0
  cluster_id                   = "awx-a-metrics-agent1-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-awx-a-metrics-agent1["node_type"]
  num_cache_nodes              = var.memcached-awx-a-metrics-agent1["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-a-metrics-agent1["ticket"]
  }
}

resource "aws_route53_record" "awx-a-metrics-agent1_cname" {
  count   = var.memcached-awx-a-metrics-agent1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-a-metrics-agent1--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-a-metrics-agent1[count.index].cluster_address]
}

##########################
# awx-a-metrics-agent2
##########################
variable "memcached-awx-a-metrics-agent2" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "awx-a-metrics-agent2" {
  count                        = var.memcached-awx-a-metrics-agent2["create"] ? 1 : 0
  cluster_id                   = "awx-a-metrics-agent2-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-awx-a-metrics-agent2["node_type"]
  num_cache_nodes              = var.memcached-awx-a-metrics-agent2["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "olympus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-awx-a-metrics-agent2["ticket"]
  }
}

resource "aws_route53_record" "awx-a-metrics-agent2_cname" {
  count   = var.memcached-awx-a-metrics-agent2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "awx-a-metrics-agent2--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.awx-a-metrics-agent2[count.index].cluster_address]
}

##########################
# dealestate-cache
##########################
variable "memcached-dealestate-cache" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "dealestate-cache" {
  count                        = var.memcached-dealestate-cache["create"] ? 1 : 0
  cluster_id                   = "dealestate-cache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.12"
  apply_immediately            = true
  node_type                    = var.memcached-dealestate-cache["node_type"]
  num_cache_nodes              = var.memcached-dealestate-cache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "deal-estate"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-dealestate-cache["ticket"]
  }
}

resource "aws_route53_record" "dealestate-cache_cname" {
  count   = var.memcached-dealestate-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dealestate-cache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.dealestate-cache[count.index].cluster_address]
}

##########################
# unwrap
##########################
variable "memcached-unwrap" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-unwrap-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "unwrap" {
  count                        = var.memcached-unwrap["create"] ? 1 : 0
  cluster_id                   = "unwrap-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-unwrap["node_type"]
  num_cache_nodes              = var.memcached-unwrap["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-unwrap-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "unwrap"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-unwrap["ticket"]
  }
}

resource "aws_route53_record" "unwrap_cname" {
  count   = var.memcached-unwrap["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "unwrap--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.unwrap[count.index].cluster_address]
}

##########################
# cont-pages
##########################
variable "memcached-cont-pages" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "cont-pages" {
  count                        = var.memcached-cont-pages["create"] ? 1 : 0
  cluster_id                   = "cont-pages-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-cont-pages["node_type"]
  num_cache_nodes              = var.memcached-cont-pages["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "content-pages"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-cont-pages["ticket"]
  }
}

resource "aws_route53_record" "cont-pages_cname" {
  count   = var.memcached-cont-pages["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "content-pages--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.cont-pages[count.index].cluster_address]
}

##########################
# deal
##########################
variable "memcached-deal" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-deal-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "deal" {
  count                        = var.memcached-deal["create"] ? 1 : 0
  cluster_id                   = "deal-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.12"
  apply_immediately            = true
  node_type                    = var.memcached-deal["node_type"]
  num_cache_nodes              = var.memcached-deal["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-deal-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "deal"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-deal["ticket"]
  }
}

resource "aws_route53_record" "deal_cname" {
  count   = var.memcached-deal["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deal--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.deal[count.index].cluster_address]
}

##########################
# checkout
##########################
variable "memcached-checkout" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "checkout" {
  count                        = var.memcached-checkout["create"] ? 1 : 0
  cluster_id                   = "checkout-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-checkout["node_type"]
  num_cache_nodes              = var.memcached-checkout["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "checkout-itier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-checkout["ticket"]
  }
}

resource "aws_route53_record" "checkout_cname" {
  count   = var.memcached-checkout["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "checkout-itier--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.checkout[count.index].cluster_address]
}

##########################
# coupons
##########################
variable "memcached-coupons" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "coupons" {
  count                        = var.memcached-coupons["create"] ? 1 : 0
  cluster_id                   = "coupons-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-coupons["node_type"]
  num_cache_nodes              = var.memcached-coupons["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "coupons-itier-global"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-coupons["ticket"]
  }
}

resource "aws_route53_record" "coupons_cname" {
  count   = var.memcached-coupons["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "coupons-itier-global--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.coupons[count.index].cluster_address]
}

##########################
# pull
##########################
variable "memcached-pull" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-pull-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "pull" {
  count                        = var.memcached-pull["create"] ? 1 : 0
  cluster_id                   = "pull-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-pull["node_type"]
  num_cache_nodes              = var.memcached-pull["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-pull-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "pull"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-pull["ticket"]
  }
}

resource "aws_route53_record" "pull_cname" {
  count   = var.memcached-pull["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "pull--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.pull[count.index].cluster_address]
}

##########################
# skeletor-nex
##########################
variable "memcached-skeletor-nex" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-skeletor-nex-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "skeletor-nex" {
  count                        = var.memcached-skeletor-nex["create"] ? 1 : 0
  cluster_id                   = "skeletor-nex-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-skeletor-nex["node_type"]
  num_cache_nodes              = var.memcached-skeletor-nex["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-skeletor-nex-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "skeletor-node-examples"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-skeletor-nex["ticket"]
  }
}

resource "aws_route53_record" "skeletor-nex_cname" {
  count   = var.memcached-skeletor-nex["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "skeletor-node-examples--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.skeletor-nex[count.index].cluster_address]
}

##########################
# goods
##########################
variable "memcached-goods" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-goods-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "goods" {
  count                        = var.memcached-goods["create"] ? 1 : 0
  cluster_id                   = "goods-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-goods["node_type"]
  num_cache_nodes              = var.memcached-goods["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-goods-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "goods"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-goods["ticket"]
  }
}

resource "aws_route53_record" "goods_cname" {
  count   = var.memcached-goods["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goods--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.goods[count.index].cluster_address]
}

##########################
# track-order
##########################
variable "memcached-track-order" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-track-order-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "track-order" {
  count                        = var.memcached-track-order["create"] ? 1 : 0
  cluster_id                   = "track-order-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.10"
  apply_immediately            = true
  node_type                    = var.memcached-track-order["node_type"]
  num_cache_nodes              = var.memcached-track-order["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-track-order-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "track-order-itier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-track-order["ticket"]
  }
}

resource "aws_route53_record" "track-order_cname" {
  count   = var.memcached-track-order["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "track-order-itier--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.track-order[count.index].cluster_address]
}

##########################
# sub-center
##########################
variable "memcached-sub-center" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-sub-center-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "sub-center" {
  count                        = var.memcached-sub-center["create"] ? 1 : 0
  cluster_id                   = "sub-center-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-sub-center["node_type"]
  num_cache_nodes              = var.memcached-sub-center["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-sub-center-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "sub-center"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-sub-center["ticket"]
  }
}

resource "aws_route53_record" "sub-center_cname" {
  count   = var.memcached-sub-center["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "sub-center--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.sub-center[count.index].cluster_address]
}

##########################
# itier-ls-voucher-archive
##########################
variable "memcached-itier-ls-voucher-archive" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-itier-ls-voucher-archive-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "itier-ls-voucher-archive" {
  count                        = var.memcached-itier-ls-voucher-archive["create"] ? 1 : 0
  cluster_id                   = "itier-ls-voucher-archive-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-itier-ls-voucher-archive["node_type"]
  num_cache_nodes              = var.memcached-itier-ls-voucher-archive["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-itier-ls-voucher-archive-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "itier-ls-voucher-archive"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-itier-ls-voucher-archive["ticket"]
  }
}

resource "aws_route53_record" "itier-ls-voucher-archive_cname" {
  count   = var.memcached-itier-ls-voucher-archive["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "itier-ls-voucher-archive--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.itier-ls-voucher-archive[count.index].cluster_address]
}

##########################
# clo-campaign
##########################
variable "memcached-clo-campaign" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "clo-campaign" {
  count                        = var.memcached-clo-campaign["create"] ? 1 : 0
  cluster_id                   = "clo-campaign-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-clo-campaign["node_type"]
  num_cache_nodes              = var.memcached-clo-campaign["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "clo-campaign"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-clo-campaign["ticket"]
  }
}

resource "aws_route53_record" "clo-campaign_cname" {
  count   = var.memcached-clo-campaign["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "clo-campaign--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.clo-campaign[count.index].cluster_address]
}

##########################
# my-account-itier
##########################
variable "memcached-my-account-itier" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-my-account-itier-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "my-account-itier" {
  count                        = var.memcached-my-account-itier["create"] ? 1 : 0
  cluster_id                   = "my-account-itier-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-my-account-itier["node_type"]
  num_cache_nodes              = var.memcached-my-account-itier["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-my-account-itier-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "my-account-itier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-my-account-itier["ticket"]
  }
}

resource "aws_route53_record" "my-account-itier_cname" {
  count   = var.memcached-my-account-itier["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "my-account-itier--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.my-account-itier[count.index].cluster_address]
}

##########################
# subscription-flow
##########################
variable "memcached-subscription-flow" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-subscription-flow-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "subscription-flow" {
  count                        = var.memcached-subscription-flow["create"] ? 1 : 0
  cluster_id                   = "subscription-flow-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-subscription-flow["node_type"]
  num_cache_nodes              = var.memcached-subscription-flow["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-subscription-flow-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "subscription-flow"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-subscription-flow["ticket"]
  }
}

resource "aws_route53_record" "subscription-flow_cname" {
  count   = var.memcached-subscription-flow["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "subscription-flow--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.subscription-flow[count.index].cluster_address]
}

##########################
# clo-itier
##########################
variable "memcached-clo-itier" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "clo-itier" {
  count                        = var.memcached-clo-itier["create"] ? 1 : 0
  cluster_id                   = "clo-itier-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-clo-itier["node_type"]
  num_cache_nodes              = var.memcached-clo-itier["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "clo-itier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-clo-itier["ticket"]
  }
}

resource "aws_route53_record" "clo-itier_cname" {
  count   = var.memcached-clo-itier["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "clo-itier--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.clo-itier[count.index].cluster_address]
}

##########################
# subscription-programs-itier
##########################
variable "memcached-subscription-programs-itier" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-subscription-programs-itier-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "subscription-programs-itier" {
  count                        = var.memcached-subscription-programs-itier["create"] ? 1 : 0
  cluster_id                   = "subscription-programs-itier-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-subscription-programs-itier["node_type"]
  num_cache_nodes              = var.memcached-subscription-programs-itier["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-subscription-programs-itier-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "subscription-programs-itier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-subscription-programs-itier["ticket"]
  }
}

resource "aws_route53_record" "subscription-programs-itier_cname" {
  count   = var.memcached-subscription-programs-itier["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "subscription-programs-itier--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.subscription-programs-itier[count.index].cluster_address]
}

##########################
# itier-support
##########################
variable "memcached-itier-support" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-itier-support-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "itier-support" {
  count                        = var.memcached-itier-support["create"] ? 1 : 0
  cluster_id                   = "itier-support-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-itier-support["node_type"]
  num_cache_nodes              = var.memcached-itier-support["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-itier-support-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "customer-support"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-itier-support["ticket"]
  }
}

resource "aws_route53_record" "itier-support_cname" {
  count   = var.memcached-itier-support["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "itier-support--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.itier-support[count.index].cluster_address]
}

##########################
# getaways-browse
##########################
variable "memcached-getaways-browse" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "getaways-browse" {
  count                        = var.memcached-getaways-browse["create"] ? 1 : 0
  cluster_id                   = "getaways-browse-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-getaways-browse["node_type"]
  num_cache_nodes              = var.memcached-getaways-browse["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "getaways-browse"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-getaways-browse["ticket"]
  }
}

resource "aws_route53_record" "getaways-browse_cname" {
  count   = var.memcached-getaways-browse["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "getaways-browse--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.getaways-browse[count.index].cluster_address]
}

##########################
# tpis-booking-ita
##########################
variable "memcached-tpis-booking-ita" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-tpis-booking-ita-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "tpis-booking-ita" {
  count                        = var.memcached-tpis-booking-ita["create"] ? 1 : 0
  cluster_id                   = "tpis-booking-ita-${var.env}"
  engine                       = local.engine
  engine_version               = "1.5.16"
  apply_immediately            = true
  node_type                    = var.memcached-tpis-booking-ita["node_type"]
  num_cache_nodes              = var.memcached-tpis-booking-ita["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-tpis-booking-ita-AZs
  parameter_group_name         = "default.memcached1.5"
  port                         = 11211

  tags = {
    TenantService   = "tpis-booking-ita"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-tpis-booking-ita["ticket"]
  }
}

resource "aws_route53_record" "tpis-booking-ita_cname" {
  count   = var.memcached-tpis-booking-ita["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "tpis-booking-ita--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.tpis-booking-ita[count.index].cluster_address]
}

##########################
# gfi-cache
##########################
variable "memcached-gfi-cache" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-gfi-cache-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "gfi-cache" {
  count                        = var.memcached-gfi-cache["create"] ? 1 : 0
  cluster_id                   = "gfi-cache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-gfi-cache["node_type"]
  num_cache_nodes              = var.memcached-gfi-cache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-gfi-cache-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "gfi"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-gfi-cache["ticket"]
  }
}

resource "aws_route53_record" "gfi-cache_cname" {
  count   = var.memcached-gfi-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "gfi-cache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.gfi-cache[count.index].cluster_address]
}

##########################
# editorial-writers-cache
##########################
variable "memcached-editorial-writers-cache" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "editorial-writers-cache" {
  count                        = var.memcached-editorial-writers-cache["create"] ? 1 : 0
  cluster_id                   = "editorial-writers-cache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-editorial-writers-cache["node_type"]
  num_cache_nodes              = var.memcached-editorial-writers-cache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "gazebo"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-editorial-writers-cache["ticket"]
  }
}

resource "aws_route53_record" "editorial-writers-cache_cname" {
  count   = var.memcached-editorial-writers-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "editorial-writers-cache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.editorial-writers-cache[count.index].cluster_address]
}

##########################
# goods-outbound-controller
##########################
variable "memcached-goods-outbound-controller" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-goods-outbound-controller-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "goods-outbound-controller" {
  count                        = var.memcached-goods-outbound-controller["create"] ? 1 : 0
  cluster_id                   = "goods-outbound-controller-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-goods-outbound-controller["node_type"]
  num_cache_nodes              = var.memcached-goods-outbound-controller["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-goods-outbound-controller-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "goods-outbound-controller"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-goods-outbound-controller["ticket"]
  }
}

resource "aws_route53_record" "goods-outbound-controller_cname" {
  count   = var.memcached-goods-outbound-controller["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goods-outbound-controller--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.goods-outbound-controller[count.index].cluster_address]
}

##########################
# goodscentral-cache
##########################
variable "memcached-goodscentral-cache" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-goodscentral-cache-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "goodscentral-cache" {
  count                        = var.memcached-goodscentral-cache["create"] ? 1 : 0
  cluster_id                   = "goodscentral-cache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-goodscentral-cache["node_type"]
  num_cache_nodes              = var.memcached-goodscentral-cache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-goodscentral-cache-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "goods_commerce_interface"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-goodscentral-cache["ticket"]
  }
}

resource "aws_route53_record" "goodscentral-cache_cname" {
  count   = var.memcached-goodscentral-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goodscentral-cache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.goodscentral-cache[count.index].cluster_address]
}

##########################
# booking-engine-appointments1
##########################
variable "memcached-booking-engine-appointments1" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "booking-engine-appointments1" {
  count                        = var.memcached-booking-engine-appointments1["create"] ? 1 : 0
  cluster_id                   = "booking-engine-appointments1-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-booking-engine-appointments1["node_type"]
  num_cache_nodes              = var.memcached-booking-engine-appointments1["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "appointment_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-booking-engine-appointments1["ticket"]
  }
}

resource "aws_route53_record" "booking-engine-appointments1_cname" {
  count   = var.memcached-booking-engine-appointments1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "booking-engine-appointments1--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.booking-engine-appointments1[count.index].cluster_address]
}

##########################
# booking-engine-appointments2
##########################
variable "memcached-booking-engine-appointments2" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "booking-engine-appointments2" {
  count                        = var.memcached-booking-engine-appointments2["create"] ? 1 : 0
  cluster_id                   = "booking-engine-appointments2-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-booking-engine-appointments2["node_type"]
  num_cache_nodes              = var.memcached-booking-engine-appointments2["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "appointment_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-booking-engine-appointments2["ticket"]
  }
}

resource "aws_route53_record" "booking-engine-appointments2_cname" {
  count   = var.memcached-booking-engine-appointments2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "booking-engine-appointments2--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.booking-engine-appointments2[count.index].cluster_address]
}

##########################
# booking-engine-appointments3
##########################
variable "memcached-booking-engine-appointments3" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "booking-engine-appointments3" {
  count                        = var.memcached-booking-engine-appointments3["create"] ? 1 : 0
  cluster_id                   = "booking-engine-appointments3-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-booking-engine-appointments3["node_type"]
  num_cache_nodes              = var.memcached-booking-engine-appointments3["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "appointment_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-booking-engine-appointments3["ticket"]
  }
}

resource "aws_route53_record" "booking-engine-appointments3_cname" {
  count   = var.memcached-booking-engine-appointments3["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "booking-engine-appointments3--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.booking-engine-appointments3[count.index].cluster_address]
}

##########################
# booking-engine-appointments4
##########################
variable "memcached-booking-engine-appointments4" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "booking-engine-appointments4" {
  count                        = var.memcached-booking-engine-appointments4["create"] ? 1 : 0
  cluster_id                   = "booking-engine-appointments4-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-booking-engine-appointments4["node_type"]
  num_cache_nodes              = var.memcached-booking-engine-appointments4["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "appointment_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-booking-engine-appointments4["ticket"]
  }
}

resource "aws_route53_record" "booking-engine-appointments4_cname" {
  count   = var.memcached-booking-engine-appointments4["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "booking-engine-appointments4--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.booking-engine-appointments4[count.index].cluster_address]
}

##########################
# users-service-cache
##########################
variable "memcached-users-service-cache" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-users-service-cache-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "users-service-cache" {
  count                        = var.memcached-users-service-cache["create"] ? 1 : 0
  cluster_id                   = "users-service-cache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-users-service-cache["node_type"]
  num_cache_nodes              = var.memcached-users-service-cache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-users-service-cache-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "users-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-users-service-cache["ticket"]
  }
}

resource "aws_route53_record" "users-service-cache_cname" {
  count   = var.memcached-users-service-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "users-service-cache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.users-service-cache[count.index].cluster_address]
}

##########################
# getaways-extranet
##########################
variable "memcached-getaways-extranet" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-getaways-extranet-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "getaways-extranet" {
  count                        = var.memcached-getaways-extranet["create"] ? 1 : 0
  cluster_id                   = "getaways-extranet-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-getaways-extranet["node_type"]
  num_cache_nodes              = var.memcached-getaways-extranet["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-getaways-extranet-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "getaways-extranet"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-getaways-extranet["ticket"]
  }
}

resource "aws_route53_record" "getaways-extranet_cname" {
  count   = var.memcached-getaways-extranet["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "getaways-extranet--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.getaways-extranet[count.index].cluster_address]
}

##########################
# accounting-service-memcache
##########################
variable "memcached-accounting-service-memcache" {
  type = map

  default = {
    create = false
  }
}

variable "memcached-accounting-service-memcache-AZs" {
  type    = list
  default = []
}

resource "aws_elasticache_cluster" "accounting-service-memcache" {
  count                        = var.memcached-accounting-service-memcache["create"] ? 1 : 0
  cluster_id                   = "accounting-service-memcache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-accounting-service-memcache["node_type"]
  num_cache_nodes              = var.memcached-accounting-service-memcache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  az_mode                      = "cross-az"
  preferred_availability_zones = var.memcached-accounting-service-memcache-AZs
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "accounting_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-accounting-service-memcache["ticket"]
  }
}

resource "aws_route53_record" "accounting-service-memcache_cname" {
  count   = var.memcached-accounting-service-memcache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "accounting-service-memcache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.accounting-service-memcache[count.index].cluster_address]
}

##########################
# accounting-service-memcache01
##########################
variable "memcached-accounting-service-memcache01" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "accounting-service-memcache01" {
  count                        = var.memcached-accounting-service-memcache01["create"] ? 1 : 0
  cluster_id                   = "accounting-service-memcache01-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-accounting-service-memcache01["node_type"]
  num_cache_nodes              = var.memcached-accounting-service-memcache01["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "accounting_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-accounting-service-memcache01["ticket"]
  }
}

resource "aws_route53_record" "accounting-service-memcache01_cname" {
  count   = var.memcached-accounting-service-memcache01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "accounting-service-memcache01--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.accounting-service-memcache01[count.index].cluster_address]
}

##########################
# accounting-service-memcache02
##########################
variable "memcached-accounting-service-memcache02" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "accounting-service-memcache02" {
  count                        = var.memcached-accounting-service-memcache02["create"] ? 1 : 0
  cluster_id                   = "accounting-service-memcache02-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-accounting-service-memcache02["node_type"]
  num_cache_nodes              = var.memcached-accounting-service-memcache02["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "accounting_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-accounting-service-memcache02["ticket"]
  }
}

resource "aws_route53_record" "accounting-service-memcache02_cname" {
  count   = var.memcached-accounting-service-memcache02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "accounting-service-memcache02--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.accounting-service-memcache02[count.index].cluster_address]
}

##########################
# accounting-service-memcache03
##########################
variable "memcached-accounting-service-memcache03" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "accounting-service-memcache03" {
  count                        = var.memcached-accounting-service-memcache03["create"] ? 1 : 0
  cluster_id                   = "accounting-service-memcache03-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-accounting-service-memcache03["node_type"]
  num_cache_nodes              = var.memcached-accounting-service-memcache03["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "accounting_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-accounting-service-memcache03["ticket"]
  }
}

resource "aws_route53_record" "accounting-service-memcache03_cname" {
  count   = var.memcached-accounting-service-memcache03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "accounting-service-memcache03--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.accounting-service-memcache03[count.index].cluster_address]
}

##########################
# orders-cache
##########################
variable "memcached-orders-cache" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "orders-cache" {
  count                        = var.memcached-orders-cache["create"] ? 1 : 0
  cluster_id                   = "orders-cache-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-orders-cache["node_type"]
  num_cache_nodes              = var.memcached-orders-cache["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "orders"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-orders-cache["ticket"]
  }
}

resource "aws_route53_record" "orders-cache_cname" {
  count   = var.memcached-orders-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "orders-cache--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.orders-cache[count.index].cluster_address]
}

##########################
# geo-taxonomy-memcached
##########################
variable "memcached-geo-taxonomy-memcached" {
  type = map

  default = {
    create = false
  }
}

resource "aws_elasticache_cluster" "geo-taxonomy-memcached" {
  count                        = var.memcached-geo-taxonomy-memcached["create"] ? 1 : 0
  cluster_id                   = "geo-taxonomy-memcached-${var.env}"
  engine                       = local.engine
  engine_version               = "1.6.6"
  apply_immediately            = true
  node_type                    = var.memcached-geo-taxonomy-memcached["node_type"]
  num_cache_nodes              = var.memcached-geo-taxonomy-memcached["num_nodes"]
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id, aws_security_group.raas_memcached_allow_onprem.id]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211

  tags = {
    TenantService   = "geo_taxonomy"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-geo-taxonomy-memcached["ticket"]
  }
}

resource "aws_route53_record" "geo-taxonomy-memcached_cname" {
  count   = var.memcached-geo-taxonomy-memcached["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "geo-taxonomy-memcached--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.geo-taxonomy-memcached[count.index].cluster_address]
}
