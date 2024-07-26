
###############################
# test1
###############################

variable "redis-test1" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test1" {
  count                         = var.redis-test1["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test1,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test1,"snapshot_arns",null) == null ? null : split(",", var.redis-test1["snapshot_arns"])
  replication_group_id          = "test1-${var.env}"
  replication_group_description = var.redis-test1["ticket"]
  node_type                     = var.redis-test1["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test1["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "test1_cname" {
  count   = var.redis-test1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test1--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test1[count.index].primary_endpoint_address]
}

###############################
# test1a
###############################

variable "redis-test1a" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test1a" {
  count                         = var.redis-test1a["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test1a,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test1a,"snapshot_arns",null) == null ? null : split(",", var.redis-test1a["snapshot_arns"])
  replication_group_id          = "test1a-${var.env}"
  replication_group_description = var.redis-test1a["ticket"]
  node_type                     = var.redis-test1a["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  data_tiering_enabled          = true
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test1a["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test1a_cname" {
  count   = var.redis-test1a["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test1a--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test1a[count.index].primary_endpoint_address]
}

###############################
# test1b
###############################

variable "redis-test1b" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test1b" {
  count                         = var.redis-test1b["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test1b,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test1b,"snapshot_arns",null) == null ? null : split(",", var.redis-test1b["snapshot_arns"])
  replication_group_id          = "test1b-${var.env}"
  replication_group_description = var.redis-test1b["ticket"]
  node_type                     = var.redis-test1b["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  data_tiering_enabled          = true
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test1b["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test1b_cname" {
  count   = var.redis-test1b["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test1b--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test1b[count.index].primary_endpoint_address]
}

###############################
# test1c
###############################

variable "redis-test1c" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test1c" {
  count                         = var.redis-test1c["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test1c,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test1c,"snapshot_arns",null) == null ? null : split(",", var.redis-test1c["snapshot_arns"])
  replication_group_id          = "test1c-${var.env}"
  replication_group_description = var.redis-test1c["ticket"]
  node_type                     = var.redis-test1c["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  data_tiering_enabled          = true
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test1c["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test1c_cname" {
  count   = var.redis-test1c["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test1c--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test1c[count.index].primary_endpoint_address]
}

###############################
# test2
###############################

variable "redis-test2" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test2" {
  count                         = var.redis-test2["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test2,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test2,"snapshot_arns",null) == null ? null : split(",", var.redis-test2["snapshot_arns"])
  replication_group_id          = "test2-${var.env}"
  replication_group_description = var.redis-test2["ticket"]
  node_type                     = var.redis-test2["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-test2["num_nodes"]
  }

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test2["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "test2_cname" {
  count   = var.redis-test2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test2--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test2[count.index].configuration_endpoint_address]
}

###############################
# test3
###############################

variable "redis-test3" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test3" {
  count                         = var.redis-test3["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test3,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test3,"snapshot_arns",null) == null ? null : split(",", var.redis-test3["snapshot_arns"])
  replication_group_id          = "test3-${var.env}"
  replication_group_description = var.redis-test3["ticket"]
  node_type                     = var.redis-test3["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test3["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test3_cname" {
  count   = var.redis-test3["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test3--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test3[count.index].primary_endpoint_address]
}

###############################
# test3a
###############################

variable "redis-test3a" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test3a" {
  count                         = var.redis-test3a["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test3a,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test3a,"snapshot_arns",null) == null ? null : split(",", var.redis-test3a["snapshot_arns"])
  replication_group_id          = "test3a-${var.env}"
  replication_group_description = var.redis-test3a["ticket"]
  node_type                     = var.redis-test3a["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test3a["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test3a_cname" {
  count   = var.redis-test3a["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test3a--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test3a[count.index].primary_endpoint_address]
}

###############################
# test3b
###############################

variable "redis-test3b" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test3b" {
  count                         = var.redis-test3b["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test3b,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test3b,"snapshot_arns",null) == null ? null : split(",", var.redis-test3b["snapshot_arns"])
  replication_group_id          = "test3b-${var.env}"
  replication_group_description = var.redis-test3b["ticket"]
  node_type                     = var.redis-test3b["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test3b["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test3b_cname" {
  count   = var.redis-test3b["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test3b--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test3b[count.index].primary_endpoint_address]
}

###############################
# test3c
###############################

variable "redis-test3c" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test3c" {
  count                         = var.redis-test3c["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test3c,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test3c,"snapshot_arns",null) == null ? null : split(",", var.redis-test3c["snapshot_arns"])
  replication_group_id          = "test3c-${var.env}"
  replication_group_description = var.redis-test3c["ticket"]
  node_type                     = var.redis-test3c["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test3c["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "test3c_cname" {
  count   = var.redis-test3c["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test3c--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test3c[count.index].primary_endpoint_address]
}

###############################
# test4
###############################

variable "redis-test4" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "test4" {
  count                         = var.redis-test4["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test4,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test4,"snapshot_arns",null) == null ? null : split(",", var.redis-test4["snapshot_arns"])
  replication_group_id          = "test4-${var.env}"
  replication_group_description = var.redis-test4["ticket"]
  node_type                     = var.redis-test4["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-test4["num_nodes"]
  }

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test4["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "test4_cname" {
  count   = var.redis-test4["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test4--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test4[count.index].configuration_endpoint_address]
}

###############################
# test-bast
###############################

variable "redis-test-bast" {
  type = map
  default = { create = false }
}
variable "redis_test_bast_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "test-bast" {
  count                         = var.redis-test-bast["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.5"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-test-bast,"snapshot_name","")
  snapshot_arns = lookup(var.redis-test-bast,"snapshot_arns",null) == null ? null : split(",", var.redis-test-bast["snapshot_arns"])
  replication_group_id          = "test-bast-${var.env}"
  replication_group_description = var.redis-test-bast["ticket"]
  node_type                     = var.redis-test-bast["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_test_bast_AUTH                    # bast

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-test-bast["ticket"]
    OOMAlertsOptOut = true
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "test-bast_cname" {
  count   = var.redis-test-bast["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "test-bast--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.test-bast[count.index].primary_endpoint_address]
}

###############################
# rfake1
###############################

variable "redis-rfake1" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rfake1" {
  count                         = var.redis-rfake1["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.4"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rfake1,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rfake1,"snapshot_arns",null) == null ? null : split(",", var.redis-rfake1["snapshot_arns"])
  replication_group_id          = "rfake1-${var.env}"
  replication_group_description = var.redis-rfake1["ticket"]
  node_type                     = var.redis-rfake1["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rfake1["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rfake1_cname" {
  count   = var.redis-rfake1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rfake1--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rfake1[count.index].primary_endpoint_address]
}

###############################
# rfake2
###############################

variable "redis-rfake2" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rfake2" {
  count                         = var.redis-rfake2["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.4"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rfake2,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rfake2,"snapshot_arns",null) == null ? null : split(",", var.redis-rfake2["snapshot_arns"])
  replication_group_id          = "rfake2-${var.env}"
  replication_group_description = var.redis-rfake2["ticket"]
  node_type                     = var.redis-rfake2["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rfake2["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "rfake2_cname" {
  count   = var.redis-rfake2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rfake2--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rfake2[count.index].primary_endpoint_address]
}

###############################
# api-proxy
###############################

variable "redis-api-proxy" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "api-proxy" {
  count                         = var.redis-api-proxy["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-api-proxy,"snapshot_name","")
  snapshot_arns = lookup(var.redis-api-proxy,"snapshot_arns",null) == null ? null : split(",", var.redis-api-proxy["snapshot_arns"])
  replication_group_id          = "api-proxy-${var.env}"
  replication_group_description = var.redis-api-proxy["ticket"]
  node_type                     = var.redis-api-proxy["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "api-proxy"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-api-proxy["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "api-proxy_cname" {
  count   = var.redis-api-proxy["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "api-proxy--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.api-proxy[count.index].primary_endpoint_address]
}

###############################
# taxonomyv2
###############################

variable "redis-taxonomyv2" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "taxonomyv2" {
  count                         = var.redis-taxonomyv2["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-taxonomyv2,"snapshot_name","")
  snapshot_arns = lookup(var.redis-taxonomyv2,"snapshot_arns",null) == null ? null : split(",", var.redis-taxonomyv2["snapshot_arns"])
  replication_group_id          = "taxonomyv2-${var.env}"
  replication_group_description = var.redis-taxonomyv2["ticket"]
  node_type                     = var.redis-taxonomyv2["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "taxonomyv2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-taxonomyv2["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "taxonomyv2_cname" {
  count   = var.redis-taxonomyv2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "taxonomyv2--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.taxonomyv2[count.index].primary_endpoint_address]
}

###############################
# dlsvc-shield
###############################

variable "redis-dlsvc-shield" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dlsvc-shield" {
  count                         = var.redis-dlsvc-shield["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dlsvc-shield,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dlsvc-shield,"snapshot_arns",null) == null ? null : split(",", var.redis-dlsvc-shield["snapshot_arns"])
  replication_group_id          = "dlsvc-shield-${var.env}"
  replication_group_description = var.redis-dlsvc-shield["ticket"]
  node_type                     = var.redis-dlsvc-shield["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-dlsvc-shield["num_nodes"]
  }

  tags = {
    TenantService   = "deal-catalog"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dlsvc-shield["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dlsvc-shield_cname" {
  count   = var.redis-dlsvc-shield["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dlsvc-shield--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dlsvc-shield[count.index].configuration_endpoint_address]
}

###############################
# dlsvc-shield-cache
###############################

variable "redis-dlsvc-shield-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dlsvc-shield-cache" {
  count                         = var.redis-dlsvc-shield-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dlsvc-shield-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dlsvc-shield-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-dlsvc-shield-cache["snapshot_arns"])
  replication_group_id          = "dlsvc-shield-cache-${var.env}"
  replication_group_description = var.redis-dlsvc-shield-cache["ticket"]
  node_type                     = var.redis-dlsvc-shield-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-dlsvc-shield-cache["num_nodes"]
  }

  tags = {
    TenantService   = "deal-catalog"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dlsvc-shield-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dlsvc-shield-cache_cname" {
  count   = var.redis-dlsvc-shield-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dlsvc-shield-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dlsvc-shield-cache[count.index].configuration_endpoint_address]
}

###############################
# dlsvc-shield-queue
###############################

variable "redis-dlsvc-shield-queue" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dlsvc-shield-queue" {
  count                         = var.redis-dlsvc-shield-queue["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dlsvc-shield-queue,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dlsvc-shield-queue,"snapshot_arns",null) == null ? null : split(",", var.redis-dlsvc-shield-queue["snapshot_arns"])
  replication_group_id          = "dlsvc-shield-queue-${var.env}"
  replication_group_description = var.redis-dlsvc-shield-queue["ticket"]
  node_type                     = var.redis-dlsvc-shield-queue["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal-catalog"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dlsvc-shield-queue["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dlsvc-shield-queue_cname" {
  count   = var.redis-dlsvc-shield-queue["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dlsvc-shield-queue--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dlsvc-shield-queue[count.index].primary_endpoint_address]
}

###############################
# vis
###############################

variable "redis-vis" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "vis" {
  count                         = var.redis-vis["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-vis,"snapshot_name","")
  snapshot_arns = lookup(var.redis-vis,"snapshot_arns",null) == null ? null : split(",", var.redis-vis["snapshot_arns"])
  replication_group_id          = "vis-${var.env}"
  replication_group_description = var.redis-vis["ticket"]
  node_type                     = var.redis-vis["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-vis["num_nodes"]
  }

  tags = {
    TenantService   = "voucher-inventory-jtier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-vis["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "vis_cname" {
  count   = var.redis-vis["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "vis--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.vis[count.index].configuration_endpoint_address]
}

###############################
# tpis
###############################

variable "redis-tpis" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "tpis" {
  count                         = var.redis-tpis["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-tpis,"snapshot_name","")
  snapshot_arns = lookup(var.redis-tpis,"snapshot_arns",null) == null ? null : split(",", var.redis-tpis["snapshot_arns"])
  replication_group_id          = "tpis-${var.env}"
  replication_group_description = var.redis-tpis["ticket"]
  node_type                     = var.redis-tpis["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "tpis-third-party-inventory-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-tpis["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "tpis_cname" {
  count   = var.redis-tpis["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "tpis--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.tpis[count.index].primary_endpoint_address]
}

###############################
# cobot
###############################

variable "redis-cobot" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "cobot" {
  count                         = var.redis-cobot["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-cobot,"snapshot_name","")
  snapshot_arns = lookup(var.redis-cobot,"snapshot_arns",null) == null ? null : split(",", var.redis-cobot["snapshot_arns"])
  replication_group_id          = "cobot-${var.env}"
  replication_group_description = var.redis-cobot["ticket"]
  node_type                     = var.redis-cobot["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "conveyor-cloud"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-cobot["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "cobot_cname" {
  count   = var.redis-cobot["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "cobot--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.cobot[count.index].primary_endpoint_address]
}

###############################
# true-uniques
###############################

variable "redis-true-uniques" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "true-uniques" {
  count                         = var.redis-true-uniques["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-true-uniques,"snapshot_name","")
  snapshot_arns = lookup(var.redis-true-uniques,"snapshot_arns",null) == null ? null : split(",", var.redis-true-uniques["snapshot_arns"])
  replication_group_id          = "true-uniques-${var.env}"
  replication_group_description = var.redis-true-uniques["ticket"]
  node_type                     = var.redis-true-uniques["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "birdcage"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-true-uniques["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "true-uniques_cname" {
  count   = var.redis-true-uniques["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "true-uniques--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.true-uniques[count.index].primary_endpoint_address]
}

###############################
# rfs-cache
###############################

variable "redis-rfs-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rfs-cache" {
  count                         = var.redis-rfs-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rfs-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rfs-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-rfs-cache["snapshot_arns"])
  replication_group_id          = "rfs-cache-${var.env}"
  replication_group_description = var.redis-rfs-cache["ticket"]
  node_type                     = var.redis-rfs-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "regulatory-consent-log"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rfs-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rfs-cache_cname" {
  count   = var.redis-rfs-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rfs-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rfs-cache[count.index].primary_endpoint_address]
}

###############################
# mentos-cache
###############################

variable "redis-mentos-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mentos-cache" {
  count                         = var.redis-mentos-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mentos-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mentos-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-mentos-cache["snapshot_arns"])
  replication_group_id          = "mentos-cache-${var.env}"
  replication_group_description = var.redis-mentos-cache["ticket"]
  node_type                     = var.redis-mentos-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mentos"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mentos-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "mentos-cache_cname" {
  count   = var.redis-mentos-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mentos-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mentos-cache[count.index].primary_endpoint_address]
}

###############################
# dealshow
###############################

variable "redis-dealshow" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dealshow" {
  count                         = var.redis-dealshow["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dealshow,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dealshow,"snapshot_arns",null) == null ? null : split(",", var.redis-dealshow["snapshot_arns"])
  replication_group_id          = "dealshow-${var.env}"
  replication_group_description = var.redis-dealshow["ticket"]
  node_type                     = var.redis-dealshow["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-dealshow["num_nodes"]
  }

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dealshow["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dealshow_cname" {
  count   = var.redis-dealshow["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-rt-cloud-deal-show--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dealshow[count.index].configuration_endpoint_address]
}

###############################
# rapi-rt-pag
###############################

variable "redis-rapi-rt-pag" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rapi-rt-pag" {
  count                         = var.redis-rapi-rt-pag["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rapi-rt-pag,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rapi-rt-pag,"snapshot_arns",null) == null ? null : split(",", var.redis-rapi-rt-pag["snapshot_arns"])
  replication_group_id          = "rapi-rt-pag-${var.env}"
  replication_group_description = var.redis-rapi-rt-pag["ticket"]
  node_type                     = var.redis-rapi-rt-pag["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rapi-rt-pag["num_nodes"]
  }

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rapi-rt-pag["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rapi-rt-pag_cname" {
  count   = var.redis-rapi-rt-pag["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-realtime-cloud-pagination--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rapi-rt-pag[count.index].configuration_endpoint_address]
}

###############################
# rapi-fallback
###############################

variable "redis-rapi-fallback" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rapi-fallback" {
  count                         = var.redis-rapi-fallback["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rapi-fallback,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rapi-fallback,"snapshot_arns",null) == null ? null : split(",", var.redis-rapi-fallback["snapshot_arns"])
  replication_group_id          = "rapi-fallback-${var.env}"
  replication_group_description = var.redis-rapi-fallback["ticket"]
  node_type                     = var.redis-rapi-fallback["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rapi-fallback["num_nodes"]
  }

  tags = {
    TenantService   = "relevance-fallback"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rapi-fallback["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "rapi-fallback_cname" {
  count   = var.redis-rapi-fallback["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-fallback--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rapi-fallback[count.index].configuration_endpoint_address]
}

###############################
# relevance-fallback
###############################

variable "redis-relevance-fallback" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "relevance-fallback" {
  count                         = var.redis-relevance-fallback["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-relevance-fallback,"snapshot_name","")
  snapshot_arns = lookup(var.redis-relevance-fallback,"snapshot_arns",null) == null ? null : split(",", var.redis-relevance-fallback["snapshot_arns"])
  replication_group_id          = "relevance-fallback-${var.env}"
  replication_group_description = var.redis-relevance-fallback["ticket"]
  node_type                     = var.redis-relevance-fallback["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-relevance-fallback["num_nodes"]
  }

  tags = {
    TenantService   = "relevance-fallback"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-relevance-fallback["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "relevance-fallback_cname" {
  count   = var.redis-relevance-fallback["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "relevance-fallback--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.relevance-fallback[count.index].configuration_endpoint_address]
}

###############################
# rapi-pagination
###############################

variable "redis-rapi-pagination" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rapi-pagination" {
  count                         = var.redis-rapi-pagination["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rapi-pagination,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rapi-pagination,"snapshot_arns",null) == null ? null : split(",", var.redis-rapi-pagination["snapshot_arns"])
  replication_group_id          = "rapi-pagination-${var.env}"
  replication_group_description = var.redis-rapi-pagination["ticket"]
  node_type                     = var.redis-rapi-pagination["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rapi-pagination["num_nodes"]
  }

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rapi-pagination["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rapi-pagination_cname" {
  count   = var.redis-rapi-pagination["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-pagination--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rapi-pagination[count.index].configuration_endpoint_address]
}

###############################
# rapi-hotel-show
###############################

variable "redis-rapi-hotel-show" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rapi-hotel-show" {
  count                         = var.redis-rapi-hotel-show["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rapi-hotel-show,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rapi-hotel-show,"snapshot_arns",null) == null ? null : split(",", var.redis-rapi-hotel-show["snapshot_arns"])
  replication_group_id          = "rapi-hotel-show-${var.env}"
  replication_group_description = var.redis-rapi-hotel-show["ticket"]
  node_type                     = var.redis-rapi-hotel-show["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rapi-hotel-show["num_nodes"]
  }

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rapi-hotel-show["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rapi-hotel-show_cname" {
  count   = var.redis-rapi-hotel-show["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-hotel-show--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rapi-hotel-show[count.index].configuration_endpoint_address]
}

###############################
# rapi-merchandising-show
###############################

variable "redis-rapi-merchandising-show" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rapi-merchandising-show" {
  count                         = var.redis-rapi-merchandising-show["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rapi-merchandising-show,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rapi-merchandising-show,"snapshot_arns",null) == null ? null : split(",", var.redis-rapi-merchandising-show["snapshot_arns"])
  replication_group_id          = "rapi-merchandising-show-${var.env}"
  replication_group_description = var.redis-rapi-merchandising-show["ticket"]
  node_type                     = var.redis-rapi-merchandising-show["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rapi-merchandising-show["num_nodes"]
  }

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rapi-merchandising-show["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rapi-merchandising-show_cname" {
  count   = var.redis-rapi-merchandising-show["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-merchandising-show--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rapi-merchandising-show[count.index].configuration_endpoint_address]
}

###############################
# pagination
###############################

variable "redis-pagination" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "pagination" {
  count                         = var.redis-pagination["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-pagination,"snapshot_name","")
  snapshot_arns = lookup(var.redis-pagination,"snapshot_arns",null) == null ? null : split(",", var.redis-pagination["snapshot_arns"])
  replication_group_id          = "pagination-${var.env}"
  replication_group_description = var.redis-pagination["ticket"]
  node_type                     = var.redis-pagination["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-pagination["num_nodes"]
  }

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-pagination["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "pagination_cname" {
  count   = var.redis-pagination["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "relevance-cloud-rapi-pagination--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.pagination[count.index].configuration_endpoint_address]
}

###############################
# goods-inventory-service
###############################

variable "redis-goods-inventory-service" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "goods-inventory-service" {
  count                         = var.redis-goods-inventory-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-goods-inventory-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-goods-inventory-service,"snapshot_arns",null) == null ? null : split(",", var.redis-goods-inventory-service["snapshot_arns"])
  replication_group_id          = "goods-inventory-service-${var.env}"
  replication_group_description = var.redis-goods-inventory-service["ticket"]
  node_type                     = var.redis-goods-inventory-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-goods-inventory-service["num_nodes"]
  }

  tags = {
    TenantService   = "goods-inventory-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-goods-inventory-service["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "goods-inventory-service_cname" {
  count   = var.redis-goods-inventory-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goods-inventory-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.goods-inventory-service[count.index].configuration_endpoint_address]
}

###############################
# layout-svc-templates
###############################

variable "redis-layout-svc-templates" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "layout-svc-templates" {
  count                         = var.redis-layout-svc-templates["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-layout-svc-templates,"snapshot_name","")
  snapshot_arns = lookup(var.redis-layout-svc-templates,"snapshot_arns",null) == null ? null : split(",", var.redis-layout-svc-templates["snapshot_arns"])
  replication_group_id          = "layout-svc-templates-${var.env}"
  replication_group_description = var.redis-layout-svc-templates["ticket"]
  parameter_group_name          = aws_elasticache_parameter_group.raas-redis5-allkeys-lfu.id
  node_type                     = var.redis-layout-svc-templates["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "layout-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-layout-svc-templates["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "layout-svc-templates_cname" {
  count   = var.redis-layout-svc-templates["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "layout-service-templates--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.layout-svc-templates[count.index].primary_endpoint_address]
}

###############################
# gdt-automation
###############################

variable "redis-gdt-automation" {
  type = map
  default = { create = false }
}
variable "redis_gdt_automation_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "gdt-automation" {
  count                         = var.redis-gdt-automation["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-gdt-automation,"snapshot_name","")
  snapshot_arns = lookup(var.redis-gdt-automation,"snapshot_arns",null) == null ? null : split(",", var.redis-gdt-automation["snapshot_arns"])
  replication_group_id          = "gdt-automation-${var.env}"
  replication_group_description = var.redis-gdt-automation["ticket"]
  parameter_group_name          = aws_elasticache_parameter_group.raas-redis6-allkeys-lru.id
  node_type                     = var.redis-gdt-automation["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_gdt_automation_AUTH                    # bast

  tags = {
    TenantService   = "gdt-automation-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-gdt-automation["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "gdt-automation_cname" {
  count   = var.redis-gdt-automation["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "gdt-automation--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.gdt-automation[count.index].primary_endpoint_address]
}

###############################
# m3-placeread
###############################

variable "redis-m3-placeread" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "m3-placeread" {
  count                         = var.redis-m3-placeread["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-m3-placeread,"snapshot_name","")
  snapshot_arns = lookup(var.redis-m3-placeread,"snapshot_arns",null) == null ? null : split(",", var.redis-m3-placeread["snapshot_arns"])
  replication_group_id          = "m3-placeread-${var.env}"
  replication_group_description = var.redis-m3-placeread["ticket"]
  node_type                     = var.redis-m3-placeread["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-m3-placeread["num_nodes"]
  }

  tags = {
    TenantService   = "m3_placeread"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-m3-placeread["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "m3-placeread_cname" {
  count   = var.redis-m3-placeread["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "m3-placeread--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.m3-placeread[count.index].configuration_endpoint_address]
}

###############################
# dmapi
###############################

variable "redis-dmapi" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dmapi" {
  count                         = var.redis-dmapi["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dmapi,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dmapi,"snapshot_arns",null) == null ? null : split(",", var.redis-dmapi["snapshot_arns"])
  replication_group_id          = "dmapi-${var.env}"
  replication_group_description = var.redis-dmapi["ticket"]
  node_type                     = var.redis-dmapi["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal_management_api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dmapi["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dmapi_cname" {
  count   = var.redis-dmapi["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dmapi--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dmapi[count.index].primary_endpoint_address]
}

###############################
# geo-bhuvan-cache
###############################

variable "redis-geo-bhuvan-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "geo-bhuvan-cache" {
  count                         = var.redis-geo-bhuvan-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-geo-bhuvan-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-geo-bhuvan-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-geo-bhuvan-cache["snapshot_arns"])
  replication_group_id          = "geo-bhuvan-cache-${var.env}"
  replication_group_description = var.redis-geo-bhuvan-cache["ticket"]
  node_type                     = var.redis-geo-bhuvan-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-geo-bhuvan-cache["num_nodes"]
  }

  tags = {
    TenantService   = "bhuvan"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-geo-bhuvan-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "geo-bhuvan-cache_cname" {
  count   = var.redis-geo-bhuvan-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "geo-bhuvan-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.geo-bhuvan-cache[count.index].configuration_endpoint_address]
}

###############################
# geo-bhuvan-indexer
###############################

variable "redis-geo-bhuvan-indexer" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "geo-bhuvan-indexer" {
  count                         = var.redis-geo-bhuvan-indexer["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-geo-bhuvan-indexer,"snapshot_name","")
  snapshot_arns = lookup(var.redis-geo-bhuvan-indexer,"snapshot_arns",null) == null ? null : split(",", var.redis-geo-bhuvan-indexer["snapshot_arns"])
  replication_group_id          = "geo-bhuvan-indexer-${var.env}"
  replication_group_description = var.redis-geo-bhuvan-indexer["ticket"]
  node_type                     = var.redis-geo-bhuvan-indexer["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-geo-bhuvan-indexer["num_nodes"]
  }

  tags = {
    TenantService   = "bhuvan"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-geo-bhuvan-indexer["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "geo-bhuvan-indexer_cname" {
  count   = var.redis-geo-bhuvan-indexer["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "geo-bhuvan-indexer--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.geo-bhuvan-indexer[count.index].configuration_endpoint_address]
}

###############################
# geo-bhuvan-geoms
###############################

variable "redis-geo-bhuvan-geoms" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "geo-bhuvan-geoms" {
  count                         = var.redis-geo-bhuvan-geoms["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-geo-bhuvan-geoms,"snapshot_name","")
  snapshot_arns = lookup(var.redis-geo-bhuvan-geoms,"snapshot_arns",null) == null ? null : split(",", var.redis-geo-bhuvan-geoms["snapshot_arns"])
  replication_group_id          = "geo-bhuvan-geoms-${var.env}"
  replication_group_description = var.redis-geo-bhuvan-geoms["ticket"]
  node_type                     = var.redis-geo-bhuvan-geoms["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-geo-bhuvan-geoms["num_nodes"]
  }

  tags = {
    TenantService   = "bhuvan"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-geo-bhuvan-geoms["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "geo-bhuvan-geoms_cname" {
  count   = var.redis-geo-bhuvan-geoms["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "geo-bhuvan-geoms--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.geo-bhuvan-geoms[count.index].configuration_endpoint_address]
}

###############################
# deckard-cache
###############################

variable "redis-deckard-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "deckard-cache" {
  count                         = var.redis-deckard-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-deckard-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-deckard-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-deckard-cache["snapshot_arns"])
  replication_group_id          = "deckard-cache-${var.env}"
  replication_group_description = var.redis-deckard-cache["ticket"]
  node_type                     = var.redis-deckard-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-deckard-cache["num_nodes"]
  }

  tags = {
    TenantService   = "deckard"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-deckard-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "deckard-cache_cname" {
  count   = var.redis-deckard-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deckard-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.deckard-cache[count.index].configuration_endpoint_address]
}

###############################
# deckard-async
###############################

variable "redis-deckard-async" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "deckard-async" {
  count                         = var.redis-deckard-async["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-deckard-async,"snapshot_name","")
  snapshot_arns = lookup(var.redis-deckard-async,"snapshot_arns",null) == null ? null : split(",", var.redis-deckard-async["snapshot_arns"])
  replication_group_id          = "deckard-async-${var.env}"
  replication_group_description = var.redis-deckard-async["ticket"]
  node_type                     = var.redis-deckard-async["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deckard"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-deckard-async["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "deckard-async_cname" {
  count   = var.redis-deckard-async["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deckard-async--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.deckard-async[count.index].primary_endpoint_address]
}

###############################
# cs-api
###############################

variable "redis-cs-api" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "cs-api" {
  count                         = var.redis-cs-api["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-cs-api,"snapshot_name","")
  snapshot_arns = lookup(var.redis-cs-api,"snapshot_arns",null) == null ? null : split(",", var.redis-cs-api["snapshot_arns"])
  replication_group_id          = "cs-api-${var.env}"
  replication_group_description = var.redis-cs-api["ticket"]
  node_type                     = var.redis-cs-api["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "cs-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-cs-api["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "cs-api_cname" {
  count   = var.redis-cs-api["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "cs-api--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.cs-api[count.index].primary_endpoint_address]
}

###############################
# raas-im-node1
###############################

variable "redis-raas-im-node1" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "raas-im-node1" {
  count                         = var.redis-raas-im-node1["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-raas-im-node1,"snapshot_name","")
  snapshot_arns = lookup(var.redis-raas-im-node1,"snapshot_arns",null) == null ? null : split(",", var.redis-raas-im-node1["snapshot_arns"])
  replication_group_id          = "raas-im-node1-${var.env}"
  replication_group_description = var.redis-raas-im-node1["ticket"]
  node_type                     = var.redis-raas-im-node1["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-raas-im-node1["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "raas-im-node1_cname" {
  count   = var.redis-raas-im-node1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "raas-im-node1--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.raas-im-node1[count.index].primary_endpoint_address]
}

###############################
# control-cloud
###############################

variable "redis-control-cloud" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "control-cloud" {
  count                         = var.redis-control-cloud["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-control-cloud,"snapshot_name","")
  snapshot_arns = lookup(var.redis-control-cloud,"snapshot_arns",null) == null ? null : split(",", var.redis-control-cloud["snapshot_arns"])
  replication_group_id          = "control-cloud-${var.env}"
  replication_group_description = var.redis-control-cloud["ticket"]
  node_type                     = var.redis-control-cloud["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "coupons_api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-control-cloud["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "control-cloud_cname" {
  count   = var.redis-control-cloud["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "control-cloud--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.control-cloud[count.index].primary_endpoint_address]
}

###############################
# batch-quraas
###############################

variable "redis-batch-quraas" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "batch-quraas" {
  count                         = var.redis-batch-quraas["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "5.0.6"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-batch-quraas,"snapshot_name","")
  snapshot_arns = lookup(var.redis-batch-quraas,"snapshot_arns",null) == null ? null : split(",", var.redis-batch-quraas["snapshot_arns"])
  replication_group_id          = "batch-quraas-${var.env}"
  replication_group_description = var.redis-batch-quraas["ticket"]
  node_type                     = var.redis-batch-quraas["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-batch-quraas["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "batch-quraas_cname" {
  count   = var.redis-batch-quraas["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "batch-quraas--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.batch-quraas[count.index].primary_endpoint_address]
}

###############################
# pizza-ng
###############################

variable "redis-pizza-ng" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "pizza-ng" {
  count                         = var.redis-pizza-ng["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-pizza-ng,"snapshot_name","")
  snapshot_arns = lookup(var.redis-pizza-ng,"snapshot_arns",null) == null ? null : split(",", var.redis-pizza-ng["snapshot_arns"])
  replication_group_id          = "pizza-ng-${var.env}"
  replication_group_description = var.redis-pizza-ng["ticket"]
  node_type                     = var.redis-pizza-ng["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "pizza-ng"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-pizza-ng["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "pizza-ng_cname" {
  count   = var.redis-pizza-ng["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "pizza-ng--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.pizza-ng[count.index].primary_endpoint_address]
}

###############################
# jarvis
###############################

variable "redis-jarvis" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "jarvis" {
  count                         = var.redis-jarvis["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-jarvis,"snapshot_name","")
  snapshot_arns = lookup(var.redis-jarvis,"snapshot_arns",null) == null ? null : split(",", var.redis-jarvis["snapshot_arns"])
  replication_group_id          = "jarvis-${var.env}"
  replication_group_description = var.redis-jarvis["ticket"]
  node_type                     = var.redis-jarvis["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "jarvis"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-jarvis["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "jarvis_cname" {
  count   = var.redis-jarvis["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "jarvis--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.jarvis[count.index].primary_endpoint_address]
}

###############################
# metro
###############################

variable "redis-metro" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "metro" {
  count                         = var.redis-metro["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-metro,"snapshot_name","")
  snapshot_arns = lookup(var.redis-metro,"snapshot_arns",null) == null ? null : split(",", var.redis-metro["snapshot_arns"])
  replication_group_id          = "metro-${var.env}"
  replication_group_description = var.redis-metro["ticket"]
  node_type                     = var.redis-metro["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "draft-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-metro["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "metro_cname" {
  count   = var.redis-metro["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "metro--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.metro[count.index].primary_endpoint_address]
}

###############################
# deal-book-service
###############################

variable "redis-deal-book-service" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "deal-book-service" {
  count                         = var.redis-deal-book-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-deal-book-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-deal-book-service,"snapshot_arns",null) == null ? null : split(",", var.redis-deal-book-service["snapshot_arns"])
  replication_group_id          = "deal-book-service-${var.env}"
  replication_group_description = var.redis-deal-book-service["ticket"]
  node_type                     = var.redis-deal-book-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal-book-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-deal-book-service["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "deal-book-service_cname" {
  count   = var.redis-deal-book-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deal-book-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.deal-book-service[count.index].primary_endpoint_address]
}

###############################
# im-email-payload01
###############################

variable "redis-im-email-payload01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-email-payload01" {
  count                         = var.redis-im-email-payload01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-email-payload01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-email-payload01,"snapshot_arns",null) == null ? null : split(",", var.redis-im-email-payload01["snapshot_arns"])
  replication_group_id          = "im-email-payload01-${var.env}"
  replication_group_description = var.redis-im-email-payload01["ticket"]
  node_type                     = var.redis-im-email-payload01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-email-payload01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-email-payload01_cname" {
  count   = var.redis-im-email-payload01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-email-payload01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-email-payload01[count.index].primary_endpoint_address]
}

###############################
# im-email-payload02
###############################

variable "redis-im-email-payload02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-email-payload02" {
  count                         = var.redis-im-email-payload02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-email-payload02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-email-payload02,"snapshot_arns",null) == null ? null : split(",", var.redis-im-email-payload02["snapshot_arns"])
  replication_group_id          = "im-email-payload02-${var.env}"
  replication_group_description = var.redis-im-email-payload02["ticket"]
  node_type                     = var.redis-im-email-payload02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-email-payload02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-email-payload02_cname" {
  count   = var.redis-im-email-payload02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-email-payload02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-email-payload02[count.index].primary_endpoint_address]
}

###############################
# im-email-payload03
###############################

variable "redis-im-email-payload03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-email-payload03" {
  count                         = var.redis-im-email-payload03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-email-payload03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-email-payload03,"snapshot_arns",null) == null ? null : split(",", var.redis-im-email-payload03["snapshot_arns"])
  replication_group_id          = "im-email-payload03-${var.env}"
  replication_group_description = var.redis-im-email-payload03["ticket"]
  node_type                     = var.redis-im-email-payload03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-email-payload03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-email-payload03_cname" {
  count   = var.redis-im-email-payload03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-email-payload03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-email-payload03[count.index].primary_endpoint_address]
}

###############################
# im-email-payload04
###############################

variable "redis-im-email-payload04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-email-payload04" {
  count                         = var.redis-im-email-payload04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-email-payload04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-email-payload04,"snapshot_arns",null) == null ? null : split(",", var.redis-im-email-payload04["snapshot_arns"])
  replication_group_id          = "im-email-payload04-${var.env}"
  replication_group_description = var.redis-im-email-payload04["ticket"]
  node_type                     = var.redis-im-email-payload04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-email-payload04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-email-payload04_cname" {
  count   = var.redis-im-email-payload04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-email-payload04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-email-payload04[count.index].primary_endpoint_address]
}

###############################
# im-mobile-payload01
###############################

variable "redis-im-mobile-payload01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-mobile-payload01" {
  count                         = var.redis-im-mobile-payload01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-mobile-payload01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-mobile-payload01,"snapshot_arns",null) == null ? null : split(",", var.redis-im-mobile-payload01["snapshot_arns"])
  replication_group_id          = "im-mobile-payload01-${var.env}"
  replication_group_description = var.redis-im-mobile-payload01["ticket"]
  node_type                     = var.redis-im-mobile-payload01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-mobile-payload01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-mobile-payload01_cname" {
  count   = var.redis-im-mobile-payload01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-mobile-payload01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-mobile-payload01[count.index].primary_endpoint_address]
}

###############################
# im-mobile-payload02
###############################

variable "redis-im-mobile-payload02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-mobile-payload02" {
  count                         = var.redis-im-mobile-payload02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-mobile-payload02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-mobile-payload02,"snapshot_arns",null) == null ? null : split(",", var.redis-im-mobile-payload02["snapshot_arns"])
  replication_group_id          = "im-mobile-payload02-${var.env}"
  replication_group_description = var.redis-im-mobile-payload02["ticket"]
  node_type                     = var.redis-im-mobile-payload02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-mobile-payload02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-mobile-payload02_cname" {
  count   = var.redis-im-mobile-payload02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-mobile-payload02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-mobile-payload02[count.index].primary_endpoint_address]
}

###############################
# im-email-events01
###############################

variable "redis-im-email-events01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-email-events01" {
  count                         = var.redis-im-email-events01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-email-events01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-email-events01,"snapshot_arns",null) == null ? null : split(",", var.redis-im-email-events01["snapshot_arns"])
  replication_group_id          = "im-email-events01-${var.env}"
  replication_group_description = var.redis-im-email-events01["ticket"]
  node_type                     = var.redis-im-email-events01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-email-events01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-email-events01_cname" {
  count   = var.redis-im-email-events01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-email-events01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-email-events01[count.index].primary_endpoint_address]
}

###############################
# im-email-events02
###############################

variable "redis-im-email-events02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-email-events02" {
  count                         = var.redis-im-email-events02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-email-events02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-email-events02,"snapshot_arns",null) == null ? null : split(",", var.redis-im-email-events02["snapshot_arns"])
  replication_group_id          = "im-email-events02-${var.env}"
  replication_group_description = var.redis-im-email-events02["ticket"]
  node_type                     = var.redis-im-email-events02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-email-events02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-email-events02_cname" {
  count   = var.redis-im-email-events02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-email-events02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-email-events02[count.index].primary_endpoint_address]
}

###############################
# im-mobile-events01
###############################

variable "redis-im-mobile-events01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-mobile-events01" {
  count                         = var.redis-im-mobile-events01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-mobile-events01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-mobile-events01,"snapshot_arns",null) == null ? null : split(",", var.redis-im-mobile-events01["snapshot_arns"])
  replication_group_id          = "im-mobile-events01-${var.env}"
  replication_group_description = var.redis-im-mobile-events01["ticket"]
  node_type                     = var.redis-im-mobile-events01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-mobile-events01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-mobile-events01_cname" {
  count   = var.redis-im-mobile-events01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-mobile-events01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-mobile-events01[count.index].primary_endpoint_address]
}

###############################
# im-mobile-events02
###############################

variable "redis-im-mobile-events02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "im-mobile-events02" {
  count                         = var.redis-im-mobile-events02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-im-mobile-events02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-im-mobile-events02,"snapshot_arns",null) == null ? null : split(",", var.redis-im-mobile-events02["snapshot_arns"])
  replication_group_id          = "im-mobile-events02-${var.env}"
  replication_group_description = var.redis-im-mobile-events02["ticket"]
  node_type                     = var.redis-im-mobile-events02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-im-mobile-events02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "im-mobile-events02_cname" {
  count   = var.redis-im-mobile-events02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "im-mobile-events02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.im-mobile-events02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-emea01
###############################

variable "redis-inbox-mgmt-email-emea01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-emea01" {
  count                         = var.redis-inbox-mgmt-email-emea01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-emea01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-emea01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-emea01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-emea01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-emea01["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-emea01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-emea01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-emea01_cname" {
  count   = var.redis-inbox-mgmt-email-emea01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-emea01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-emea01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-emea02
###############################

variable "redis-inbox-mgmt-email-emea02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-emea02" {
  count                         = var.redis-inbox-mgmt-email-emea02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-emea02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-emea02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-emea02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-emea02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-emea02["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-emea02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-emea02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-emea02_cname" {
  count   = var.redis-inbox-mgmt-email-emea02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-emea02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-emea02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-emea03
###############################

variable "redis-inbox-mgmt-email-emea03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-emea03" {
  count                         = var.redis-inbox-mgmt-email-emea03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-emea03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-emea03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-emea03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-emea03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-emea03["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-emea03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-emea03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-emea03_cname" {
  count   = var.redis-inbox-mgmt-email-emea03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-emea03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-emea03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-emea04
###############################

variable "redis-inbox-mgmt-email-emea04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-emea04" {
  count                         = var.redis-inbox-mgmt-email-emea04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-emea04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-emea04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-emea04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-emea04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-emea04["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-emea04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-emea04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-emea04_cname" {
  count   = var.redis-inbox-mgmt-email-emea04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-emea04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-emea04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-emea01
###############################

variable "redis-inbox-mgmt-mobile-emea01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-emea01" {
  count                         = var.redis-inbox-mgmt-mobile-emea01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-emea01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-emea01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-emea01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-emea01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-emea01["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-emea01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-emea01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-emea01_cname" {
  count   = var.redis-inbox-mgmt-mobile-emea01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-emea01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-emea01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-emea02
###############################

variable "redis-inbox-mgmt-mobile-emea02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-emea02" {
  count                         = var.redis-inbox-mgmt-mobile-emea02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-emea02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-emea02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-emea02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-emea02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-emea02["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-emea02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-emea02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-emea02_cname" {
  count   = var.redis-inbox-mgmt-mobile-emea02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-emea02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-emea02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-emea03
###############################

variable "redis-inbox-mgmt-mobile-emea03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-emea03" {
  count                         = var.redis-inbox-mgmt-mobile-emea03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-emea03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-emea03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-emea03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-emea03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-emea03["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-emea03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-emea03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-emea03_cname" {
  count   = var.redis-inbox-mgmt-mobile-emea03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-emea03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-emea03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-emea04
###############################

variable "redis-inbox-mgmt-mobile-emea04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-emea04" {
  count                         = var.redis-inbox-mgmt-mobile-emea04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-emea04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-emea04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-emea04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-emea04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-emea04["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-emea04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-emea04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-emea04_cname" {
  count   = var.redis-inbox-mgmt-mobile-emea04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-emea04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-emea04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-user-lock01
###############################

variable "redis-inbox-mgmt-user-lock01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-user-lock01" {
  count                         = var.redis-inbox-mgmt-user-lock01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-user-lock01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-user-lock01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-user-lock01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-user-lock01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-user-lock01["ticket"]
  node_type                     = var.redis-inbox-mgmt-user-lock01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-user-lock01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-user-lock01_cname" {
  count   = var.redis-inbox-mgmt-user-lock01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-user-lock01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-user-lock01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-user-lock02
###############################

variable "redis-inbox-mgmt-user-lock02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-user-lock02" {
  count                         = var.redis-inbox-mgmt-user-lock02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-user-lock02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-user-lock02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-user-lock02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-user-lock02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-user-lock02["ticket"]
  node_type                     = var.redis-inbox-mgmt-user-lock02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-user-lock02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-user-lock02_cname" {
  count   = var.redis-inbox-mgmt-user-lock02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-user-lock02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-user-lock02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-user-lock03
###############################

variable "redis-inbox-mgmt-user-lock03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-user-lock03" {
  count                         = var.redis-inbox-mgmt-user-lock03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-user-lock03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-user-lock03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-user-lock03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-user-lock03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-user-lock03["ticket"]
  node_type                     = var.redis-inbox-mgmt-user-lock03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-user-lock03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-user-lock03_cname" {
  count   = var.redis-inbox-mgmt-user-lock03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-user-lock03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-user-lock03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-user-lock04
###############################

variable "redis-inbox-mgmt-user-lock04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-user-lock04" {
  count                         = var.redis-inbox-mgmt-user-lock04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-user-lock04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-user-lock04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-user-lock04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-user-lock04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-user-lock04["ticket"]
  node_type                     = var.redis-inbox-mgmt-user-lock04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-user-lock04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-user-lock04_cname" {
  count   = var.redis-inbox-mgmt-user-lock04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-user-lock04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-user-lock04[count.index].primary_endpoint_address]
}

###############################
# badges
###############################

variable "redis-badges" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "badges" {
  count                         = var.redis-badges["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-badges,"snapshot_name","")
  snapshot_arns = lookup(var.redis-badges,"snapshot_arns",null) == null ? null : split(",", var.redis-badges["snapshot_arns"])
  replication_group_id          = "badges-${var.env}"
  replication_group_description = var.redis-badges["ticket"]
  node_type                     = var.redis-badges["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_gcp_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-badges["num_nodes"]
  }

  tags = {
    TenantService   = "badges-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-badges["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "badges_cname" {
  count   = var.redis-badges["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "badges-service-cloud--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.badges[count.index].configuration_endpoint_address]
}

###############################
# pt-service-cache
###############################

variable "redis-pt-service-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "pt-service-cache" {
  count                         = var.redis-pt-service-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-pt-service-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-pt-service-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-pt-service-cache["snapshot_arns"])
  replication_group_id          = "pt-service-cache-${var.env}"
  replication_group_description = var.redis-pt-service-cache["ticket"]
  node_type                     = var.redis-pt-service-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "perf-tools-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-pt-service-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "pt-service-cache_cname" {
  count   = var.redis-pt-service-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "pt-service-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.pt-service-cache[count.index].primary_endpoint_address]
}

###############################
# accounting-service
###############################

variable "redis-accounting-service" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "accounting-service" {
  count                         = var.redis-accounting-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-accounting-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-accounting-service,"snapshot_arns",null) == null ? null : split(",", var.redis-accounting-service["snapshot_arns"])
  replication_group_id          = "accounting-service-${var.env}"
  replication_group_description = var.redis-accounting-service["ticket"]
  node_type                     = var.redis-accounting-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "accounting_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-accounting-service["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "accounting-service_cname" {
  count   = var.redis-accounting-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "accounting-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.accounting-service[count.index].primary_endpoint_address]
}

###############################
# da-s2s
###############################

variable "redis-da-s2s" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "da-s2s" {
  count                         = var.redis-da-s2s["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-da-s2s,"snapshot_name","")
  snapshot_arns = lookup(var.redis-da-s2s,"snapshot_arns",null) == null ? null : split(",", var.redis-da-s2s["snapshot_arns"])
  replication_group_id          = "da-s2s-${var.env}"
  replication_group_description = var.redis-da-s2s["ticket"]
  node_type                     = var.redis-da-s2s["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "da-s2s"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-da-s2s["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "da-s2s_cname" {
  count   = var.redis-da-s2s["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "da-s2s--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.da-s2s[count.index].primary_endpoint_address]
}

###############################
# bros-cache
###############################

variable "redis-bros-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "bros-cache" {
  count                         = var.redis-bros-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-bros-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-bros-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-bros-cache["snapshot_arns"])
  replication_group_id          = "bros-cache-${var.env}"
  replication_group_description = var.redis-bros-cache["ticket"]
  node_type                     = var.redis-bros-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "bros"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-bros-cache["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "bros-cache_cname" {
  count   = var.redis-bros-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "bros-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.bros-cache[count.index].primary_endpoint_address]
}

###############################
# proximity-cache
###############################

variable "redis-proximity-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "proximity-cache" {
  count                         = var.redis-proximity-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-proximity-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-proximity-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-proximity-cache["snapshot_arns"])
  replication_group_id          = "proximity-cache-${var.env}"
  replication_group_description = var.redis-proximity-cache["ticket"]
  node_type                     = var.redis-proximity-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "proximity_notifications"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-proximity-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "proximity-cache_cname" {
  count   = var.redis-proximity-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "proximity-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.proximity-cache[count.index].primary_endpoint_address]
}

###############################
# regla
###############################

variable "redis-regla" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "regla" {
  count                         = var.redis-regla["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-regla,"snapshot_name","")
  snapshot_arns = lookup(var.redis-regla,"snapshot_arns",null) == null ? null : split(",", var.redis-regla["snapshot_arns"])
  replication_group_id          = "regla-${var.env}"
  replication_group_description = var.redis-regla["ticket"]
  node_type                     = var.redis-regla["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "regla"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-regla["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "regla_cname" {
  count   = var.redis-regla["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "regla--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.regla[count.index].primary_endpoint_address]
}

###############################
# targeted-deal-message-cache
###############################

variable "redis-targeted-deal-message-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "targeted-deal-message-cache" {
  count                         = var.redis-targeted-deal-message-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-targeted-deal-message-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-targeted-deal-message-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-targeted-deal-message-cache["snapshot_arns"])
  replication_group_id          = "targeted-deal-message-cache-${var.env}"
  replication_group_description = var.redis-targeted-deal-message-cache["ticket"]
  node_type                     = var.redis-targeted-deal-message-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_gcp_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "targeted-deal-message"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-targeted-deal-message-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "targeted-deal-message-cache_cname" {
  count   = var.redis-targeted-deal-message-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "targeted-deal-message-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.targeted-deal-message-cache[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users01
###############################

variable "redis-inbox-mgmt-email-prod-users01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users01" {
  count                         = var.redis-inbox-mgmt-email-prod-users01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users01["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users01_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users01
###############################

variable "redis-inbox-mgmt-mobile-prod-users01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users01" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users01["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users01_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users02
###############################

variable "redis-inbox-mgmt-email-prod-users02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users02" {
  count                         = var.redis-inbox-mgmt-email-prod-users02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users02["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users02_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users02
###############################

variable "redis-inbox-mgmt-mobile-prod-users02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users02" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users02["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users02_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users03
###############################

variable "redis-inbox-mgmt-email-prod-users03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users03" {
  count                         = var.redis-inbox-mgmt-email-prod-users03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users03["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users03_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users03
###############################

variable "redis-inbox-mgmt-mobile-prod-users03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users03" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users03["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users03_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users04
###############################

variable "redis-inbox-mgmt-email-prod-users04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users04" {
  count                         = var.redis-inbox-mgmt-email-prod-users04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users04["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users04_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users04
###############################

variable "redis-inbox-mgmt-mobile-prod-users04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users04" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users04["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users04_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users05
###############################

variable "redis-inbox-mgmt-email-prod-users05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users05" {
  count                         = var.redis-inbox-mgmt-email-prod-users05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users05,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users05["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users05-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users05["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users05_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users05[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users05
###############################

variable "redis-inbox-mgmt-mobile-prod-users05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users05" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users05,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users05["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users05-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users05["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users05_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users05[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users06
###############################

variable "redis-inbox-mgmt-email-prod-users06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users06" {
  count                         = var.redis-inbox-mgmt-email-prod-users06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users06,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users06["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users06-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users06["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users06_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users06[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users06
###############################

variable "redis-inbox-mgmt-mobile-prod-users06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users06" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users06,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users06["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users06-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users06["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users06_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users06[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users07
###############################

variable "redis-inbox-mgmt-email-prod-users07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users07" {
  count                         = var.redis-inbox-mgmt-email-prod-users07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users07,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users07["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users07-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users07["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users07_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users07[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users07
###############################

variable "redis-inbox-mgmt-mobile-prod-users07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users07" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users07,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users07["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users07-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users07["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users07_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users07[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users08
###############################

variable "redis-inbox-mgmt-email-prod-users08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users08" {
  count                         = var.redis-inbox-mgmt-email-prod-users08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users08,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users08["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users08-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users08["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users08_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users08[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users08
###############################

variable "redis-inbox-mgmt-mobile-prod-users08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users08" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users08,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users08["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users08-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users08["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users08_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users08[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users09
###############################

variable "redis-inbox-mgmt-email-prod-users09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users09" {
  count                         = var.redis-inbox-mgmt-email-prod-users09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users09,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users09["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users09-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users09["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users09_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users09[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users09
###############################

variable "redis-inbox-mgmt-mobile-prod-users09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users09" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users09,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users09["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users09-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users09["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users09_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users09[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users10
###############################

variable "redis-inbox-mgmt-email-prod-users10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users10" {
  count                         = var.redis-inbox-mgmt-email-prod-users10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users10,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users10["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users10-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users10["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users10_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users10[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users10
###############################

variable "redis-inbox-mgmt-mobile-prod-users10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users10" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users10,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users10["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users10-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users10["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users10_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users10[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users11
###############################

variable "redis-inbox-mgmt-email-prod-users11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users11" {
  count                         = var.redis-inbox-mgmt-email-prod-users11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users11,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users11["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users11-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users11["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users11_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users11[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users11
###############################

variable "redis-inbox-mgmt-mobile-prod-users11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users11" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users11,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users11["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users11-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users11["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users11_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users11[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users12
###############################

variable "redis-inbox-mgmt-email-prod-users12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users12" {
  count                         = var.redis-inbox-mgmt-email-prod-users12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users12,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users12["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users12-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users12["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users12_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users12[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users12
###############################

variable "redis-inbox-mgmt-mobile-prod-users12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users12" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users12,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users12["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users12-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users12["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users12_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users12[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users13
###############################

variable "redis-inbox-mgmt-email-prod-users13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users13" {
  count                         = var.redis-inbox-mgmt-email-prod-users13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users13,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users13["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users13-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users13["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users13_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users13[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users13
###############################

variable "redis-inbox-mgmt-mobile-prod-users13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users13" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users13,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users13["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users13-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users13["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users13_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users13[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users14
###############################

variable "redis-inbox-mgmt-email-prod-users14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users14" {
  count                         = var.redis-inbox-mgmt-email-prod-users14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users14,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users14["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users14-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users14["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users14_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users14[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users14
###############################

variable "redis-inbox-mgmt-mobile-prod-users14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users14" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users14,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users14["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users14-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users14["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users14_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users14[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users15
###############################

variable "redis-inbox-mgmt-email-prod-users15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users15" {
  count                         = var.redis-inbox-mgmt-email-prod-users15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users15,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users15["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users15-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users15["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users15_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users15[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users15
###############################

variable "redis-inbox-mgmt-mobile-prod-users15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users15" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users15,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users15["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users15-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users15["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users15_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users15[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users16
###############################

variable "redis-inbox-mgmt-email-prod-users16" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users16" {
  count                         = var.redis-inbox-mgmt-email-prod-users16["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users16,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users16,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users16["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users16-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users16["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users16["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users16["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users16_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users16["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users16--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users16[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users16
###############################

variable "redis-inbox-mgmt-mobile-prod-users16" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users16" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users16["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users16,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users16,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users16["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users16-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users16["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users16["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users16["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users16_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users16["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users16--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users16[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users17
###############################

variable "redis-inbox-mgmt-email-prod-users17" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users17" {
  count                         = var.redis-inbox-mgmt-email-prod-users17["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users17,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users17,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users17["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users17-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users17["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users17["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users17["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users17_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users17["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users17--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users17[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users17
###############################

variable "redis-inbox-mgmt-mobile-prod-users17" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users17" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users17["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users17,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users17,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users17["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users17-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users17["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users17["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users17["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users17_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users17["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users17--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users17[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users18
###############################

variable "redis-inbox-mgmt-email-prod-users18" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users18" {
  count                         = var.redis-inbox-mgmt-email-prod-users18["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users18,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users18,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users18["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users18-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users18["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users18["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users18["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users18_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users18["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users18--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users18[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users18
###############################

variable "redis-inbox-mgmt-mobile-prod-users18" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users18" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users18["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users18,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users18,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users18["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users18-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users18["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users18["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users18["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users18_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users18["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users18--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users18[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users19
###############################

variable "redis-inbox-mgmt-email-prod-users19" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users19" {
  count                         = var.redis-inbox-mgmt-email-prod-users19["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users19,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users19,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users19["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users19-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users19["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users19["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users19["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users19_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users19["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users19--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users19[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users19
###############################

variable "redis-inbox-mgmt-mobile-prod-users19" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users19" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users19["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users19,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users19,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users19["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users19-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users19["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users19["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users19["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users19_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users19["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users19--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users19[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users20
###############################

variable "redis-inbox-mgmt-email-prod-users20" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users20" {
  count                         = var.redis-inbox-mgmt-email-prod-users20["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users20,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users20,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users20["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users20-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users20["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users20["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users20["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users20_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users20["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users20--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users20[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users20
###############################

variable "redis-inbox-mgmt-mobile-prod-users20" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users20" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users20["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users20,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users20,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users20["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users20-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users20["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users20["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users20["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users20_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users20["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users20--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users20[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users21
###############################

variable "redis-inbox-mgmt-email-prod-users21" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users21" {
  count                         = var.redis-inbox-mgmt-email-prod-users21["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users21,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users21,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users21["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users21-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users21["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users21["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users21["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users21_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users21["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users21--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users21[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users21
###############################

variable "redis-inbox-mgmt-mobile-prod-users21" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users21" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users21["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users21,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users21,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users21["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users21-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users21["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users21["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users21["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users21_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users21["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users21--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users21[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users22
###############################

variable "redis-inbox-mgmt-email-prod-users22" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users22" {
  count                         = var.redis-inbox-mgmt-email-prod-users22["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users22,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users22,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users22["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users22-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users22["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users22["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users22["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users22_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users22["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users22--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users22[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users22
###############################

variable "redis-inbox-mgmt-mobile-prod-users22" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users22" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users22["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users22,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users22,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users22["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users22-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users22["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users22["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users22["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users22_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users22["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users22--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users22[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users23
###############################

variable "redis-inbox-mgmt-email-prod-users23" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users23" {
  count                         = var.redis-inbox-mgmt-email-prod-users23["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users23,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users23,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users23["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users23-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users23["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users23["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users23["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users23_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users23["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users23--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users23[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users23
###############################

variable "redis-inbox-mgmt-mobile-prod-users23" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users23" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users23["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users23,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users23,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users23["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users23-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users23["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users23["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users23["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users23_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users23["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users23--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users23[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users24
###############################

variable "redis-inbox-mgmt-email-prod-users24" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users24" {
  count                         = var.redis-inbox-mgmt-email-prod-users24["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users24,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users24,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users24["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users24-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users24["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users24["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users24["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users24_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users24["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users24--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users24[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users24
###############################

variable "redis-inbox-mgmt-mobile-prod-users24" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users24" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users24["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users24,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users24,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users24["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users24-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users24["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users24["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users24["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users24_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users24["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users24--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users24[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users25
###############################

variable "redis-inbox-mgmt-email-prod-users25" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users25" {
  count                         = var.redis-inbox-mgmt-email-prod-users25["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users25,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users25,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users25["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users25-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users25["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users25["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users25["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users25_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users25["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users25--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users25[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users25
###############################

variable "redis-inbox-mgmt-mobile-prod-users25" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users25" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users25["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users25,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users25,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users25["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users25-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users25["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users25["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users25["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users25_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users25["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users25--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users25[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users26
###############################

variable "redis-inbox-mgmt-email-prod-users26" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users26" {
  count                         = var.redis-inbox-mgmt-email-prod-users26["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users26,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users26,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users26["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users26-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users26["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users26["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users26["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users26_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users26["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users26--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users26[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users26
###############################

variable "redis-inbox-mgmt-mobile-prod-users26" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users26" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users26["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users26,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users26,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users26["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users26-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users26["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users26["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users26["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users26_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users26["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users26--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users26[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users27
###############################

variable "redis-inbox-mgmt-email-prod-users27" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users27" {
  count                         = var.redis-inbox-mgmt-email-prod-users27["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users27,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users27,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users27["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users27-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users27["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users27["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users27["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users27_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users27["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users27--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users27[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users27
###############################

variable "redis-inbox-mgmt-mobile-prod-users27" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users27" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users27["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users27,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users27,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users27["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users27-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users27["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users27["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users27["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users27_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users27["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users27--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users27[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users28
###############################

variable "redis-inbox-mgmt-email-prod-users28" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users28" {
  count                         = var.redis-inbox-mgmt-email-prod-users28["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users28,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users28,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users28["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users28-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users28["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users28["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users28["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users28_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users28["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users28--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users28[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users28
###############################

variable "redis-inbox-mgmt-mobile-prod-users28" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users28" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users28["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users28,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users28,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users28["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users28-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users28["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users28["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users28["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users28_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users28["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users28--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users28[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users29
###############################

variable "redis-inbox-mgmt-email-prod-users29" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users29" {
  count                         = var.redis-inbox-mgmt-email-prod-users29["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users29,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users29,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users29["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users29-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users29["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users29["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users29["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users29_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users29["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users29--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users29[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users29
###############################

variable "redis-inbox-mgmt-mobile-prod-users29" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users29" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users29["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users29,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users29,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users29["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users29-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users29["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users29["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users29["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users29_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users29["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users29--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users29[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users30
###############################

variable "redis-inbox-mgmt-email-prod-users30" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users30" {
  count                         = var.redis-inbox-mgmt-email-prod-users30["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users30,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users30,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users30["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users30-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users30["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users30["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users30["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users30_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users30["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users30--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users30[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users30
###############################

variable "redis-inbox-mgmt-mobile-prod-users30" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users30" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users30["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users30,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users30,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users30["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users30-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users30["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users30["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users30["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users30_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users30["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users30--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users30[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users31
###############################

variable "redis-inbox-mgmt-email-prod-users31" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users31" {
  count                         = var.redis-inbox-mgmt-email-prod-users31["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users31,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users31,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users31["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users31-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users31["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users31["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users31["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users31_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users31["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users31--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users31[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users31
###############################

variable "redis-inbox-mgmt-mobile-prod-users31" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users31" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users31["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users31,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users31,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users31["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users31-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users31["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users31["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users31["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users31_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users31["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users31--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users31[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-users32
###############################

variable "redis-inbox-mgmt-email-prod-users32" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-users32" {
  count                         = var.redis-inbox-mgmt-email-prod-users32["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-users32,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-users32,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-users32["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-users32-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-users32["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-users32["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-users32["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-users32_cname" {
  count   = var.redis-inbox-mgmt-email-prod-users32["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-users32--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-users32[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-users32
###############################

variable "redis-inbox-mgmt-mobile-prod-users32" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-users32" {
  count                         = var.redis-inbox-mgmt-mobile-prod-users32["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-users32,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-users32,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-users32["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-users32-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-users32["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-users32["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-users32["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-users32_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-users32["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-users32--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-users32[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events01
###############################

variable "redis-inbox-mgmt-email-prod-events01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events01" {
  count                         = var.redis-inbox-mgmt-email-prod-events01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events01["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events01_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events01
###############################

variable "redis-inbox-mgmt-mobile-prod-events01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events01" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events01["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events01_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events02
###############################

variable "redis-inbox-mgmt-email-prod-events02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events02" {
  count                         = var.redis-inbox-mgmt-email-prod-events02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events02["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events02_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events02
###############################

variable "redis-inbox-mgmt-mobile-prod-events02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events02" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events02["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events02_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events03
###############################

variable "redis-inbox-mgmt-email-prod-events03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events03" {
  count                         = var.redis-inbox-mgmt-email-prod-events03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events03["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events03_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events03
###############################

variable "redis-inbox-mgmt-mobile-prod-events03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events03" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events03["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events03_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events04
###############################

variable "redis-inbox-mgmt-email-prod-events04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events04" {
  count                         = var.redis-inbox-mgmt-email-prod-events04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events04["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events04_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events04
###############################

variable "redis-inbox-mgmt-mobile-prod-events04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events04" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events04["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events04_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events05
###############################

variable "redis-inbox-mgmt-email-prod-events05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events05" {
  count                         = var.redis-inbox-mgmt-email-prod-events05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events05,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events05["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events05-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events05["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events05_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events05[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events05
###############################

variable "redis-inbox-mgmt-mobile-prod-events05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events05" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events05,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events05["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events05-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events05["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events05_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events05[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events06
###############################

variable "redis-inbox-mgmt-email-prod-events06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events06" {
  count                         = var.redis-inbox-mgmt-email-prod-events06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events06,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events06["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events06-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events06["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events06_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events06[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events06
###############################

variable "redis-inbox-mgmt-mobile-prod-events06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events06" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events06,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events06["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events06-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events06["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events06_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events06[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events07
###############################

variable "redis-inbox-mgmt-email-prod-events07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events07" {
  count                         = var.redis-inbox-mgmt-email-prod-events07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events07,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events07["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events07-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events07["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events07_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events07[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events07
###############################

variable "redis-inbox-mgmt-mobile-prod-events07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events07" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events07,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events07["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events07-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events07["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events07_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events07[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events08
###############################

variable "redis-inbox-mgmt-email-prod-events08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events08" {
  count                         = var.redis-inbox-mgmt-email-prod-events08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events08,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events08["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events08-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events08["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events08_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events08[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events08
###############################

variable "redis-inbox-mgmt-mobile-prod-events08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events08" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events08,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events08["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events08-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events08["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events08_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events08[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events09
###############################

variable "redis-inbox-mgmt-email-prod-events09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events09" {
  count                         = var.redis-inbox-mgmt-email-prod-events09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events09,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events09["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events09-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events09["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events09_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events09[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events09
###############################

variable "redis-inbox-mgmt-mobile-prod-events09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events09" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events09,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events09["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events09-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events09["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events09_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events09[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events10
###############################

variable "redis-inbox-mgmt-email-prod-events10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events10" {
  count                         = var.redis-inbox-mgmt-email-prod-events10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events10,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events10["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events10-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events10["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events10_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events10[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events10
###############################

variable "redis-inbox-mgmt-mobile-prod-events10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events10" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events10,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events10["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events10-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events10["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events10_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events10[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events11
###############################

variable "redis-inbox-mgmt-email-prod-events11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events11" {
  count                         = var.redis-inbox-mgmt-email-prod-events11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events11,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events11["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events11-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events11["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events11_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events11[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events11
###############################

variable "redis-inbox-mgmt-mobile-prod-events11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events11" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events11,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events11["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events11-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events11["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events11_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events11[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events12
###############################

variable "redis-inbox-mgmt-email-prod-events12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events12" {
  count                         = var.redis-inbox-mgmt-email-prod-events12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events12,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events12["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events12-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events12["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events12_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events12[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events12
###############################

variable "redis-inbox-mgmt-mobile-prod-events12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events12" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events12,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events12["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events12-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events12["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events12_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events12[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events13
###############################

variable "redis-inbox-mgmt-email-prod-events13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events13" {
  count                         = var.redis-inbox-mgmt-email-prod-events13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events13,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events13["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events13-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events13["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events13_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events13[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events13
###############################

variable "redis-inbox-mgmt-mobile-prod-events13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events13" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events13,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events13["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events13-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events13["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events13_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events13[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events14
###############################

variable "redis-inbox-mgmt-email-prod-events14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events14" {
  count                         = var.redis-inbox-mgmt-email-prod-events14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events14,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events14["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events14-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events14["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events14_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events14[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events14
###############################

variable "redis-inbox-mgmt-mobile-prod-events14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events14" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events14,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events14["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events14-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events14["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events14_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events14[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events15
###############################

variable "redis-inbox-mgmt-email-prod-events15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events15" {
  count                         = var.redis-inbox-mgmt-email-prod-events15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events15,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events15["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events15-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events15["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events15_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events15[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events15
###############################

variable "redis-inbox-mgmt-mobile-prod-events15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events15" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events15,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events15["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events15-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events15["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events15_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events15[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events16
###############################

variable "redis-inbox-mgmt-email-prod-events16" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events16" {
  count                         = var.redis-inbox-mgmt-email-prod-events16["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events16,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events16,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events16["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events16-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events16["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events16["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events16["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events16_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events16["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events16--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events16[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events16
###############################

variable "redis-inbox-mgmt-mobile-prod-events16" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events16" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events16["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events16,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events16,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events16["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events16-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events16["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events16["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events16["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events16_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events16["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events16--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events16[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events17
###############################

variable "redis-inbox-mgmt-email-prod-events17" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events17" {
  count                         = var.redis-inbox-mgmt-email-prod-events17["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events17,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events17,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events17["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events17-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events17["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events17["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events17["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events17_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events17["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events17--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events17[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events17
###############################

variable "redis-inbox-mgmt-mobile-prod-events17" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events17" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events17["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events17,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events17,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events17["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events17-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events17["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events17["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events17["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events17_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events17["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events17--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events17[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events18
###############################

variable "redis-inbox-mgmt-email-prod-events18" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events18" {
  count                         = var.redis-inbox-mgmt-email-prod-events18["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events18,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events18,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events18["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events18-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events18["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events18["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events18["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events18_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events18["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events18--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events18[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events18
###############################

variable "redis-inbox-mgmt-mobile-prod-events18" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events18" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events18["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events18,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events18,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events18["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events18-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events18["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events18["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events18["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events18_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events18["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events18--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events18[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events19
###############################

variable "redis-inbox-mgmt-email-prod-events19" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events19" {
  count                         = var.redis-inbox-mgmt-email-prod-events19["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events19,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events19,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events19["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events19-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events19["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events19["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events19["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events19_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events19["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events19--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events19[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events19
###############################

variable "redis-inbox-mgmt-mobile-prod-events19" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events19" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events19["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events19,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events19,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events19["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events19-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events19["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events19["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events19["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events19_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events19["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events19--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events19[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events20
###############################

variable "redis-inbox-mgmt-email-prod-events20" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events20" {
  count                         = var.redis-inbox-mgmt-email-prod-events20["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events20,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events20,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events20["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events20-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events20["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events20["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events20["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events20_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events20["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events20--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events20[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events20
###############################

variable "redis-inbox-mgmt-mobile-prod-events20" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events20" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events20["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events20,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events20,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events20["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events20-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events20["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events20["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events20["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events20_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events20["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events20--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events20[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events21
###############################

variable "redis-inbox-mgmt-email-prod-events21" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events21" {
  count                         = var.redis-inbox-mgmt-email-prod-events21["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events21,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events21,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events21["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events21-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events21["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events21["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events21["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events21_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events21["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events21--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events21[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events21
###############################

variable "redis-inbox-mgmt-mobile-prod-events21" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events21" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events21["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events21,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events21,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events21["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events21-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events21["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events21["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events21["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events21_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events21["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events21--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events21[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events22
###############################

variable "redis-inbox-mgmt-email-prod-events22" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events22" {
  count                         = var.redis-inbox-mgmt-email-prod-events22["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events22,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events22,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events22["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events22-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events22["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events22["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events22["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events22_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events22["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events22--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events22[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events22
###############################

variable "redis-inbox-mgmt-mobile-prod-events22" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events22" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events22["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events22,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events22,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events22["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events22-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events22["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events22["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events22["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events22_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events22["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events22--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events22[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events23
###############################

variable "redis-inbox-mgmt-email-prod-events23" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events23" {
  count                         = var.redis-inbox-mgmt-email-prod-events23["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events23,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events23,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events23["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events23-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events23["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events23["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events23["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events23_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events23["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events23--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events23[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events23
###############################

variable "redis-inbox-mgmt-mobile-prod-events23" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events23" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events23["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events23,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events23,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events23["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events23-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events23["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events23["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events23["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events23_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events23["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events23--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events23[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events24
###############################

variable "redis-inbox-mgmt-email-prod-events24" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events24" {
  count                         = var.redis-inbox-mgmt-email-prod-events24["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events24,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events24,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events24["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events24-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events24["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events24["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events24["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events24_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events24["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events24--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events24[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events24
###############################

variable "redis-inbox-mgmt-mobile-prod-events24" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events24" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events24["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events24,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events24,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events24["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events24-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events24["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events24["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events24["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events24_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events24["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events24--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events24[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events25
###############################

variable "redis-inbox-mgmt-email-prod-events25" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events25" {
  count                         = var.redis-inbox-mgmt-email-prod-events25["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events25,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events25,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events25["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events25-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events25["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events25["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events25["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events25_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events25["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events25--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events25[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events25
###############################

variable "redis-inbox-mgmt-mobile-prod-events25" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events25" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events25["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events25,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events25,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events25["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events25-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events25["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events25["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events25["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events25_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events25["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events25--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events25[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events26
###############################

variable "redis-inbox-mgmt-email-prod-events26" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events26" {
  count                         = var.redis-inbox-mgmt-email-prod-events26["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events26,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events26,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events26["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events26-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events26["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events26["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events26["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events26_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events26["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events26--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events26[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events26
###############################

variable "redis-inbox-mgmt-mobile-prod-events26" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events26" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events26["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events26,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events26,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events26["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events26-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events26["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events26["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events26["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events26_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events26["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events26--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events26[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events27
###############################

variable "redis-inbox-mgmt-email-prod-events27" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events27" {
  count                         = var.redis-inbox-mgmt-email-prod-events27["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events27,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events27,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events27["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events27-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events27["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events27["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events27["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events27_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events27["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events27--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events27[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events27
###############################

variable "redis-inbox-mgmt-mobile-prod-events27" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events27" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events27["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events27,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events27,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events27["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events27-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events27["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events27["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events27["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events27_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events27["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events27--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events27[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events28
###############################

variable "redis-inbox-mgmt-email-prod-events28" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events28" {
  count                         = var.redis-inbox-mgmt-email-prod-events28["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events28,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events28,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events28["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events28-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events28["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events28["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events28["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events28_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events28["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events28--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events28[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events28
###############################

variable "redis-inbox-mgmt-mobile-prod-events28" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events28" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events28["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events28,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events28,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events28["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events28-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events28["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events28["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events28["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events28_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events28["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events28--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events28[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events29
###############################

variable "redis-inbox-mgmt-email-prod-events29" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events29" {
  count                         = var.redis-inbox-mgmt-email-prod-events29["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events29,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events29,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events29["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events29-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events29["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events29["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events29["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events29_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events29["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events29--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events29[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events29
###############################

variable "redis-inbox-mgmt-mobile-prod-events29" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events29" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events29["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events29,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events29,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events29["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events29-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events29["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events29["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events29["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events29_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events29["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events29--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events29[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events30
###############################

variable "redis-inbox-mgmt-email-prod-events30" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events30" {
  count                         = var.redis-inbox-mgmt-email-prod-events30["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events30,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events30,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events30["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events30-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events30["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events30["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events30["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events30_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events30["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events30--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events30[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events30
###############################

variable "redis-inbox-mgmt-mobile-prod-events30" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events30" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events30["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events30,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events30,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events30["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events30-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events30["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events30["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events30["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events30_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events30["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events30--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events30[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events31
###############################

variable "redis-inbox-mgmt-email-prod-events31" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events31" {
  count                         = var.redis-inbox-mgmt-email-prod-events31["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events31,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events31,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events31["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events31-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events31["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events31["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events31["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events31_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events31["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events31--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events31[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events31
###############################

variable "redis-inbox-mgmt-mobile-prod-events31" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events31" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events31["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events31,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events31,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events31["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events31-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events31["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events31["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events31["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events31_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events31["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events31--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events31[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-events32
###############################

variable "redis-inbox-mgmt-email-prod-events32" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-events32" {
  count                         = var.redis-inbox-mgmt-email-prod-events32["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-events32,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-events32,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-events32["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-events32-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-events32["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-events32["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-events32["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-events32_cname" {
  count   = var.redis-inbox-mgmt-email-prod-events32["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-events32--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-events32[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-events32
###############################

variable "redis-inbox-mgmt-mobile-prod-events32" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-events32" {
  count                         = var.redis-inbox-mgmt-mobile-prod-events32["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-events32,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-events32,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-events32["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-events32-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-events32["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-events32["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-events32["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-events32_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-events32["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-events32--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-events32[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload01
###############################

variable "redis-inbox-mgmt-email-prod-payload01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload01" {
  count                         = var.redis-inbox-mgmt-email-prod-payload01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload01["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload01_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload01
###############################

variable "redis-inbox-mgmt-mobile-prod-payload01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload01" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload01["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload01_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload02
###############################

variable "redis-inbox-mgmt-email-prod-payload02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload02" {
  count                         = var.redis-inbox-mgmt-email-prod-payload02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload02["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload02_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload02
###############################

variable "redis-inbox-mgmt-mobile-prod-payload02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload02" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload02,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload02["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload02-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload02["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload02_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload02[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload03
###############################

variable "redis-inbox-mgmt-email-prod-payload03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload03" {
  count                         = var.redis-inbox-mgmt-email-prod-payload03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload03["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload03_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload03
###############################

variable "redis-inbox-mgmt-mobile-prod-payload03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload03" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload03,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload03["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload03-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload03["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload03_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload03[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload04
###############################

variable "redis-inbox-mgmt-email-prod-payload04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload04" {
  count                         = var.redis-inbox-mgmt-email-prod-payload04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload04["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload04_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload04
###############################

variable "redis-inbox-mgmt-mobile-prod-payload04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload04" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload04,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload04["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload04-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload04["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload04_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload04[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload05
###############################

variable "redis-inbox-mgmt-email-prod-payload05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload05" {
  count                         = var.redis-inbox-mgmt-email-prod-payload05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload05,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload05["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload05-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload05["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload05_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload05[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload05
###############################

variable "redis-inbox-mgmt-mobile-prod-payload05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload05" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload05,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload05["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload05-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload05["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload05_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload05[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload06
###############################

variable "redis-inbox-mgmt-email-prod-payload06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload06" {
  count                         = var.redis-inbox-mgmt-email-prod-payload06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload06,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload06["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload06-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload06["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload06_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload06[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload06
###############################

variable "redis-inbox-mgmt-mobile-prod-payload06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload06" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload06,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload06["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload06-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload06["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload06_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload06[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload07
###############################

variable "redis-inbox-mgmt-email-prod-payload07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload07" {
  count                         = var.redis-inbox-mgmt-email-prod-payload07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload07,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload07["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload07-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload07["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload07_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload07[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload07
###############################

variable "redis-inbox-mgmt-mobile-prod-payload07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload07" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload07,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload07["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload07-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload07["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload07_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload07[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload08
###############################

variable "redis-inbox-mgmt-email-prod-payload08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload08" {
  count                         = var.redis-inbox-mgmt-email-prod-payload08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload08,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload08["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload08-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload08["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload08_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload08[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload08
###############################

variable "redis-inbox-mgmt-mobile-prod-payload08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload08" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload08,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload08["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload08-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload08["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload08_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload08[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload09
###############################

variable "redis-inbox-mgmt-email-prod-payload09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload09" {
  count                         = var.redis-inbox-mgmt-email-prod-payload09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload09,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload09["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload09-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload09["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload09_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload09[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload09
###############################

variable "redis-inbox-mgmt-mobile-prod-payload09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload09" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload09,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload09["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload09-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload09["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload09_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload09[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload10
###############################

variable "redis-inbox-mgmt-email-prod-payload10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload10" {
  count                         = var.redis-inbox-mgmt-email-prod-payload10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload10,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload10["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload10-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload10["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload10_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload10[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload10
###############################

variable "redis-inbox-mgmt-mobile-prod-payload10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload10" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload10,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload10["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload10-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload10["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload10_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload10[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload11
###############################

variable "redis-inbox-mgmt-email-prod-payload11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload11" {
  count                         = var.redis-inbox-mgmt-email-prod-payload11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload11,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload11["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload11-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload11["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload11_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload11[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload11
###############################

variable "redis-inbox-mgmt-mobile-prod-payload11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload11" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload11,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload11["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload11-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload11["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload11_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload11[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload12
###############################

variable "redis-inbox-mgmt-email-prod-payload12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload12" {
  count                         = var.redis-inbox-mgmt-email-prod-payload12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload12,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload12["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload12-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload12["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload12_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload12[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload12
###############################

variable "redis-inbox-mgmt-mobile-prod-payload12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload12" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload12,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload12["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload12-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload12["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload12_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload12[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload13
###############################

variable "redis-inbox-mgmt-email-prod-payload13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload13" {
  count                         = var.redis-inbox-mgmt-email-prod-payload13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload13,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload13["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload13-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload13["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload13_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload13[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload13
###############################

variable "redis-inbox-mgmt-mobile-prod-payload13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload13" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload13,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload13["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload13-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload13["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload13_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload13[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload14
###############################

variable "redis-inbox-mgmt-email-prod-payload14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload14" {
  count                         = var.redis-inbox-mgmt-email-prod-payload14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload14,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload14["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload14-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload14["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload14_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload14[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload14
###############################

variable "redis-inbox-mgmt-mobile-prod-payload14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload14" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload14,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload14["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload14-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload14["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload14_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload14[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload15
###############################

variable "redis-inbox-mgmt-email-prod-payload15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload15" {
  count                         = var.redis-inbox-mgmt-email-prod-payload15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload15,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload15["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload15-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload15["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload15_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload15[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload15
###############################

variable "redis-inbox-mgmt-mobile-prod-payload15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload15" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload15,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload15["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload15-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload15["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload15_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload15[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload16
###############################

variable "redis-inbox-mgmt-email-prod-payload16" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload16" {
  count                         = var.redis-inbox-mgmt-email-prod-payload16["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload16,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload16,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload16["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload16-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload16["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload16["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload16["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload16_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload16["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload16--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload16[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload16
###############################

variable "redis-inbox-mgmt-mobile-prod-payload16" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload16" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload16["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload16,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload16,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload16["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload16-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload16["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload16["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload16["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload16_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload16["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload16--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload16[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload17
###############################

variable "redis-inbox-mgmt-email-prod-payload17" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload17" {
  count                         = var.redis-inbox-mgmt-email-prod-payload17["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload17,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload17,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload17["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload17-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload17["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload17["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload17["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload17_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload17["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload17--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload17[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload17
###############################

variable "redis-inbox-mgmt-mobile-prod-payload17" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload17" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload17["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload17,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload17,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload17["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload17-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload17["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload17["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload17["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload17_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload17["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload17--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload17[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload18
###############################

variable "redis-inbox-mgmt-email-prod-payload18" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload18" {
  count                         = var.redis-inbox-mgmt-email-prod-payload18["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload18,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload18,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload18["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload18-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload18["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload18["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload18["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload18_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload18["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload18--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload18[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload18
###############################

variable "redis-inbox-mgmt-mobile-prod-payload18" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload18" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload18["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload18,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload18,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload18["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload18-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload18["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload18["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload18["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload18_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload18["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload18--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload18[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload19
###############################

variable "redis-inbox-mgmt-email-prod-payload19" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload19" {
  count                         = var.redis-inbox-mgmt-email-prod-payload19["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload19,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload19,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload19["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload19-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload19["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload19["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload19["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload19_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload19["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload19--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload19[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload19
###############################

variable "redis-inbox-mgmt-mobile-prod-payload19" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload19" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload19["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload19,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload19,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload19["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload19-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload19["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload19["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload19["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload19_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload19["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload19--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload19[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload20
###############################

variable "redis-inbox-mgmt-email-prod-payload20" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload20" {
  count                         = var.redis-inbox-mgmt-email-prod-payload20["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload20,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload20,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload20["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload20-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload20["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload20["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload20["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload20_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload20["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload20--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload20[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload20
###############################

variable "redis-inbox-mgmt-mobile-prod-payload20" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload20" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload20["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload20,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload20,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload20["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload20-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload20["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload20["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload20["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload20_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload20["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload20--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload20[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload21
###############################

variable "redis-inbox-mgmt-email-prod-payload21" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload21" {
  count                         = var.redis-inbox-mgmt-email-prod-payload21["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload21,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload21,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload21["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload21-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload21["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload21["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload21["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload21_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload21["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload21--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload21[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload21
###############################

variable "redis-inbox-mgmt-mobile-prod-payload21" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload21" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload21["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload21,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload21,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload21["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload21-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload21["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload21["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload21["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload21_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload21["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload21--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload21[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload22
###############################

variable "redis-inbox-mgmt-email-prod-payload22" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload22" {
  count                         = var.redis-inbox-mgmt-email-prod-payload22["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload22,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload22,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload22["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload22-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload22["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload22["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload22["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload22_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload22["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload22--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload22[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload22
###############################

variable "redis-inbox-mgmt-mobile-prod-payload22" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload22" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload22["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload22,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload22,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload22["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload22-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload22["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload22["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload22["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload22_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload22["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload22--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload22[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload23
###############################

variable "redis-inbox-mgmt-email-prod-payload23" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload23" {
  count                         = var.redis-inbox-mgmt-email-prod-payload23["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload23,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload23,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload23["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload23-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload23["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload23["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload23["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload23_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload23["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload23--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload23[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload23
###############################

variable "redis-inbox-mgmt-mobile-prod-payload23" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload23" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload23["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload23,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload23,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload23["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload23-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload23["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload23["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload23["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload23_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload23["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload23--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload23[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload24
###############################

variable "redis-inbox-mgmt-email-prod-payload24" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload24" {
  count                         = var.redis-inbox-mgmt-email-prod-payload24["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload24,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload24,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload24["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload24-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload24["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload24["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload24["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload24_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload24["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload24--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload24[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload24
###############################

variable "redis-inbox-mgmt-mobile-prod-payload24" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload24" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload24["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload24,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload24,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload24["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload24-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload24["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload24["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload24["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload24_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload24["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload24--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload24[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload25
###############################

variable "redis-inbox-mgmt-email-prod-payload25" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload25" {
  count                         = var.redis-inbox-mgmt-email-prod-payload25["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload25,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload25,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload25["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload25-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload25["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload25["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload25["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload25_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload25["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload25--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload25[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload25
###############################

variable "redis-inbox-mgmt-mobile-prod-payload25" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload25" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload25["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload25,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload25,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload25["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload25-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload25["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload25["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload25["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload25_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload25["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload25--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload25[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload26
###############################

variable "redis-inbox-mgmt-email-prod-payload26" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload26" {
  count                         = var.redis-inbox-mgmt-email-prod-payload26["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload26,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload26,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload26["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload26-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload26["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload26["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload26["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload26_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload26["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload26--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload26[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload26
###############################

variable "redis-inbox-mgmt-mobile-prod-payload26" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload26" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload26["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload26,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload26,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload26["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload26-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload26["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload26["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload26["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload26_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload26["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload26--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload26[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload27
###############################

variable "redis-inbox-mgmt-email-prod-payload27" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload27" {
  count                         = var.redis-inbox-mgmt-email-prod-payload27["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload27,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload27,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload27["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload27-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload27["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload27["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload27["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload27_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload27["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload27--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload27[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload27
###############################

variable "redis-inbox-mgmt-mobile-prod-payload27" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload27" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload27["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload27,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload27,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload27["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload27-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload27["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload27["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload27["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload27_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload27["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload27--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload27[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload28
###############################

variable "redis-inbox-mgmt-email-prod-payload28" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload28" {
  count                         = var.redis-inbox-mgmt-email-prod-payload28["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload28,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload28,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload28["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload28-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload28["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload28["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload28["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload28_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload28["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload28--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload28[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload28
###############################

variable "redis-inbox-mgmt-mobile-prod-payload28" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload28" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload28["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload28,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload28,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload28["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload28-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload28["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload28["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload28["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload28_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload28["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload28--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload28[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload29
###############################

variable "redis-inbox-mgmt-email-prod-payload29" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload29" {
  count                         = var.redis-inbox-mgmt-email-prod-payload29["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload29,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload29,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload29["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload29-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload29["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload29["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload29["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload29_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload29["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload29--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload29[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload29
###############################

variable "redis-inbox-mgmt-mobile-prod-payload29" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload29" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload29["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload29,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload29,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload29["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload29-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload29["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload29["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload29["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload29_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload29["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload29--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload29[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload30
###############################

variable "redis-inbox-mgmt-email-prod-payload30" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload30" {
  count                         = var.redis-inbox-mgmt-email-prod-payload30["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload30,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload30,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload30["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload30-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload30["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload30["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload30["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload30_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload30["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload30--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload30[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload30
###############################

variable "redis-inbox-mgmt-mobile-prod-payload30" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload30" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload30["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload30,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload30,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload30["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload30-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload30["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload30["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload30["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload30_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload30["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload30--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload30[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload31
###############################

variable "redis-inbox-mgmt-email-prod-payload31" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload31" {
  count                         = var.redis-inbox-mgmt-email-prod-payload31["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload31,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload31,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload31["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload31-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload31["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload31["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload31["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload31_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload31["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload31--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload31[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload31
###############################

variable "redis-inbox-mgmt-mobile-prod-payload31" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload31" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload31["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload31,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload31,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload31["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload31-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload31["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload31["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload31["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload31_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload31["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload31--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload31[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-prod-payload32
###############################

variable "redis-inbox-mgmt-email-prod-payload32" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-prod-payload32" {
  count                         = var.redis-inbox-mgmt-email-prod-payload32["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-prod-payload32,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-prod-payload32,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-prod-payload32["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-prod-payload32-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-prod-payload32["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-prod-payload32["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-prod-payload32["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-prod-payload32_cname" {
  count   = var.redis-inbox-mgmt-email-prod-payload32["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-prod-payload32--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-prod-payload32[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-prod-payload32
###############################

variable "redis-inbox-mgmt-mobile-prod-payload32" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-prod-payload32" {
  count                         = var.redis-inbox-mgmt-mobile-prod-payload32["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-prod-payload32,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-prod-payload32,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-prod-payload32["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-prod-payload32-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-prod-payload32["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-prod-payload32["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-prod-payload32["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-prod-payload32_cname" {
  count   = var.redis-inbox-mgmt-mobile-prod-payload32["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-prod-payload32--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-prod-payload32[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-cmpaigncntxt
###############################

variable "redis-inbox-mgmt-email-cmpaigncntxt" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-cmpaigncntxt" {
  count                         = var.redis-inbox-mgmt-email-cmpaigncntxt["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-cmpaigncntxt,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-cmpaigncntxt,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-cmpaigncntxt["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-cmpaigncntxt-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-cmpaigncntxt["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-cmpaigncntxt["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-cmpaigncntxt["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-cmpaigncntxt_cname" {
  count   = var.redis-inbox-mgmt-email-cmpaigncntxt["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-cmpaigncntxt--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-cmpaigncntxt[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-email-cacheset
###############################

variable "redis-inbox-mgmt-email-cacheset" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-cacheset" {
  count                         = var.redis-inbox-mgmt-email-cacheset["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-cacheset,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-cacheset,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-cacheset["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-cacheset-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-cacheset["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-cacheset["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-cacheset["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-email-cacheset_cname" {
  count   = var.redis-inbox-mgmt-email-cacheset["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-cacheset--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-cacheset[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-cmpaigncntxt
###############################

variable "redis-inbox-mgmt-mobile-cmpaigncntxt" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-cmpaigncntxt" {
  count                         = var.redis-inbox-mgmt-mobile-cmpaigncntxt["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-cmpaigncntxt,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-cmpaigncntxt,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-cmpaigncntxt["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-cmpaigncntxt-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-cmpaigncntxt["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-cmpaigncntxt["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-cmpaigncntxt["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-cmpaigncntxt_cname" {
  count   = var.redis-inbox-mgmt-mobile-cmpaigncntxt["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-cmpaigncntxt--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-cmpaigncntxt[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-cacheset
###############################

variable "redis-inbox-mgmt-mobile-cacheset" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-cacheset" {
  count                         = var.redis-inbox-mgmt-mobile-cacheset["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-cacheset,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-cacheset,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-cacheset["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-cacheset-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-cacheset["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-cacheset["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-cacheset["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-cacheset_cname" {
  count   = var.redis-inbox-mgmt-mobile-cacheset["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-cacheset--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-cacheset[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-cmpaignmetrics
###############################

variable "redis-inbox-mgmt-cmpaignmetrics" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-cmpaignmetrics" {
  count                         = var.redis-inbox-mgmt-cmpaignmetrics["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-cmpaignmetrics,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-cmpaignmetrics,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-cmpaignmetrics["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-cmpaignmetrics-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-cmpaignmetrics["ticket"]
  node_type                     = var.redis-inbox-mgmt-cmpaignmetrics["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-cmpaignmetrics["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "inbox-mgmt-cmpaignmetrics_cname" {
  count   = var.redis-inbox-mgmt-cmpaignmetrics["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-cmpaignmetrics--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-cmpaignmetrics[count.index].primary_endpoint_address]
}

###############################
# goodscentral
###############################

variable "redis-goodscentral" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "goodscentral" {
  count                         = var.redis-goodscentral["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-goodscentral,"snapshot_name","")
  snapshot_arns = lookup(var.redis-goodscentral,"snapshot_arns",null) == null ? null : split(",", var.redis-goodscentral["snapshot_arns"])
  replication_group_id          = "goodscentral-${var.env}"
  replication_group_description = var.redis-goodscentral["ticket"]
  node_type                     = var.redis-goodscentral["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "goods_commerce_interface"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-goodscentral["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "goodscentral_cname" {
  count   = var.redis-goodscentral["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goodscentral--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.goodscentral[count.index].primary_endpoint_address]
}

###############################
# goodscentral-async
###############################

variable "redis-goodscentral-async" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "goodscentral-async" {
  count                         = var.redis-goodscentral-async["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-goodscentral-async,"snapshot_name","")
  snapshot_arns = lookup(var.redis-goodscentral-async,"snapshot_arns",null) == null ? null : split(",", var.redis-goodscentral-async["snapshot_arns"])
  replication_group_id          = "goodscentral-async-${var.env}"
  replication_group_description = var.redis-goodscentral-async["ticket"]
  node_type                     = var.redis-goodscentral-async["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "goods_commerce_interface"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-goodscentral-async["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "goodscentral-async_cname" {
  count   = var.redis-goodscentral-async["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goodscentral-async--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.goodscentral-async[count.index].primary_endpoint_address]
}

###############################
# item-authority
###############################

variable "redis-item-authority" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "item-authority" {
  count                         = var.redis-item-authority["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-item-authority,"snapshot_name","")
  snapshot_arns = lookup(var.redis-item-authority,"snapshot_arns",null) == null ? null : split(",", var.redis-item-authority["snapshot_arns"])
  replication_group_id          = "item-authority-${var.env}"
  replication_group_description = var.redis-item-authority["ticket"]
  node_type                     = var.redis-item-authority["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "item-authority"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-item-authority["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "item-authority_cname" {
  count   = var.redis-item-authority["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "item-authority--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.item-authority[count.index].primary_endpoint_address]
}

###############################
# lbms-cache
###############################

variable "redis-lbms-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "lbms-cache" {
  count                         = var.redis-lbms-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-lbms-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-lbms-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-lbms-cache["snapshot_arns"])
  replication_group_id          = "lbms-cache-${var.env}"
  replication_group_description = var.redis-lbms-cache["ticket"]
  node_type                     = var.redis-lbms-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "lbms"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-lbms-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "lbms-cache_cname" {
  count   = var.redis-lbms-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "lbms-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.lbms-cache[count.index].primary_endpoint_address]
}

###############################
# lbms-queue
###############################

variable "redis-lbms-queue" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "lbms-queue" {
  count                         = var.redis-lbms-queue["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-lbms-queue,"snapshot_name","")
  snapshot_arns = lookup(var.redis-lbms-queue,"snapshot_arns",null) == null ? null : split(",", var.redis-lbms-queue["snapshot_arns"])
  replication_group_id          = "lbms-queue-${var.env}"
  replication_group_description = var.redis-lbms-queue["ticket"]
  node_type                     = var.redis-lbms-queue["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "lbms"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-lbms-queue["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "lbms-queue_cname" {
  count   = var.redis-lbms-queue["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "lbms-queue--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.lbms-queue[count.index].primary_endpoint_address]
}

###############################
# merchant-data-dora
###############################

variable "redis-merchant-data-dora" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "merchant-data-dora" {
  count                         = var.redis-merchant-data-dora["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-merchant-data-dora,"snapshot_name","")
  snapshot_arns = lookup(var.redis-merchant-data-dora,"snapshot_arns",null) == null ? null : split(",", var.redis-merchant-data-dora["snapshot_arns"])
  replication_group_id          = "merchant-data-dora-${var.env}"
  replication_group_description = var.redis-merchant-data-dora["ticket"]
  node_type                     = var.redis-merchant-data-dora["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "m3_local_dora"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-merchant-data-dora["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "merchant-data-dora_cname" {
  count   = var.redis-merchant-data-dora["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "merchant-data-dora--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.merchant-data-dora[count.index].primary_endpoint_address]
}

###############################
# web-crawl
###############################

variable "redis-web-crawl" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "web-crawl" {
  count                         = var.redis-web-crawl["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-web-crawl,"snapshot_name","")
  snapshot_arns = lookup(var.redis-web-crawl,"snapshot_arns",null) == null ? null : split(",", var.redis-web-crawl["snapshot_arns"])
  replication_group_id          = "web-crawl-${var.env}"
  replication_group_description = var.redis-web-crawl["ticket"]
  node_type                     = var.redis-web-crawl["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "web-crawl"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-web-crawl["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "web-crawl_cname" {
  count   = var.redis-web-crawl["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "web-crawl--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.web-crawl[count.index].primary_endpoint_address]
}

###############################
# backbeat
###############################

variable "redis-backbeat" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "backbeat" {
  count                         = var.redis-backbeat["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-backbeat,"snapshot_name","")
  snapshot_arns = lookup(var.redis-backbeat,"snapshot_arns",null) == null ? null : split(",", var.redis-backbeat["snapshot_arns"])
  replication_group_id          = "backbeat-${var.env}"
  replication_group_description = var.redis-backbeat["ticket"]
  node_type                     = var.redis-backbeat["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "backbeat"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-backbeat["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "backbeat_cname" {
  count   = var.redis-backbeat["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "backbeat--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.backbeat[count.index].primary_endpoint_address]
}

###############################
# casesservice-cache
###############################

variable "redis-casesservice-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "casesservice-cache" {
  count                         = var.redis-casesservice-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-casesservice-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-casesservice-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-casesservice-cache["snapshot_arns"])
  replication_group_id          = "casesservice-cache-${var.env}"
  replication_group_description = var.redis-casesservice-cache["ticket"]
  parameter_group_name          = aws_elasticache_parameter_group.raas-redis6-allkeys-lru.id
  node_type                     = var.redis-casesservice-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mx-merchant-cases"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-casesservice-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "casesservice-cache_cname" {
  count   = var.redis-casesservice-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "casesservice-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.casesservice-cache[count.index].primary_endpoint_address]
}

###############################
# content-service-cache
###############################

variable "redis-content-service-cache" {
  type = map
  default = { create = false }
}
variable "redis_content_service_cache_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "content-service-cache" {
  count                         = var.redis-content-service-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-content-service-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-content-service-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-content-service-cache["snapshot_arns"])
  replication_group_id          = "content-service-cache-${var.env}"
  replication_group_description = var.redis-content-service-cache["ticket"]
  parameter_group_name          = aws_elasticache_parameter_group.raas-redis6-allkeys-lru.id
  node_type                     = var.redis-content-service-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_content_service_cache_AUTH                    # bast

  tags = {
    TenantService   = "ece-non-eng-email"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-content-service-cache["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "content-service-cache_cname" {
  count   = var.redis-content-service-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "content-service-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.content-service-cache[count.index].primary_endpoint_address]
}

###############################
# device-fingerprint-storage
###############################

variable "redis-device-fingerprint-storage" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "device-fingerprint-storage" {
  count                         = var.redis-device-fingerprint-storage["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-device-fingerprint-storage,"snapshot_name","")
  snapshot_arns = lookup(var.redis-device-fingerprint-storage,"snapshot_arns",null) == null ? null : split(",", var.redis-device-fingerprint-storage["snapshot_arns"])
  replication_group_id          = "device-fingerprint-storage-${var.env}"
  replication_group_description = var.redis-device-fingerprint-storage["ticket"]
  node_type                     = var.redis-device-fingerprint-storage["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "device_fingerprint_storage"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-device-fingerprint-storage["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "device-fingerprint-storage_cname" {
  count   = var.redis-device-fingerprint-storage["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "device-fingerprint-storage--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.device-fingerprint-storage[count.index].primary_endpoint_address]
}

###############################
# dynamo
###############################

variable "redis-dynamo" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dynamo" {
  count                         = var.redis-dynamo["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dynamo,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dynamo,"snapshot_arns",null) == null ? null : split(",", var.redis-dynamo["snapshot_arns"])
  replication_group_id          = "dynamo-${var.env}"
  replication_group_description = var.redis-dynamo["ticket"]
  node_type                     = var.redis-dynamo["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "dynamo"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dynamo["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dynamo_cname" {
  count   = var.redis-dynamo["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dynamo--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dynamo[count.index].primary_endpoint_address]
}

###############################
# gfi
###############################

variable "redis-gfi" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "gfi" {
  count                         = var.redis-gfi["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-gfi,"snapshot_name","")
  snapshot_arns = lookup(var.redis-gfi,"snapshot_arns",null) == null ? null : split(",", var.redis-gfi["snapshot_arns"])
  replication_group_id          = "gfi-${var.env}"
  replication_group_description = var.redis-gfi["ticket"]
  node_type                     = var.redis-gfi["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "gfi"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-gfi["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "gfi_cname" {
  count   = var.redis-gfi["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "gfi--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.gfi[count.index].primary_endpoint_address]
}

###############################
# custsvc-tokenizer
###############################

variable "redis-custsvc-tokenizer" {
  type = map
  default = { create = false }
}
variable "redis_custsvc_tokenizer_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "custsvc-tokenizer" {
  count                         = var.redis-custsvc-tokenizer["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-custsvc-tokenizer,"snapshot_name","")
  snapshot_arns = lookup(var.redis-custsvc-tokenizer,"snapshot_arns",null) == null ? null : split(",", var.redis-custsvc-tokenizer["snapshot_arns"])
  replication_group_id          = "custsvc-tokenizer-${var.env}"
  replication_group_description = var.redis-custsvc-tokenizer["ticket"]
  node_type                     = var.redis-custsvc-tokenizer["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_custsvc_tokenizer_AUTH                    # bast

  tags = {
    TenantService   = "cs-token-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-custsvc-tokenizer["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C1"
  }
}

resource "aws_route53_record" "custsvc-tokenizer_cname" {
  count   = var.redis-custsvc-tokenizer["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "custsvc-tokenizer--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.custsvc-tokenizer[count.index].primary_endpoint_address]
}

###############################
# deal-pwa-mirror-cache
###############################

variable "redis-deal-pwa-mirror-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "deal-pwa-mirror-cache" {
  count                         = var.redis-deal-pwa-mirror-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-deal-pwa-mirror-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-deal-pwa-mirror-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-deal-pwa-mirror-cache["snapshot_arns"])
  replication_group_id          = "deal-pwa-mirror-cache-${var.env}"
  replication_group_description = var.redis-deal-pwa-mirror-cache["ticket"]
  node_type                     = var.redis-deal-pwa-mirror-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal-catalog"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-deal-pwa-mirror-cache["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "deal-pwa-mirror-cache_cname" {
  count   = var.redis-deal-pwa-mirror-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deal-pwa-mirror-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.deal-pwa-mirror-cache[count.index].primary_endpoint_address]
}

###############################
# glive-3rd-party
###############################

variable "redis-glive-3rd-party" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "glive-3rd-party" {
  count                         = var.redis-glive-3rd-party["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-glive-3rd-party,"snapshot_name","")
  snapshot_arns = lookup(var.redis-glive-3rd-party,"snapshot_arns",null) == null ? null : split(",", var.redis-glive-3rd-party["snapshot_arns"])
  replication_group_id          = "glive-3rd-party-${var.env}"
  replication_group_description = var.redis-glive-3rd-party["ticket"]
  node_type                     = var.redis-glive-3rd-party["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "grouponlive-gtx"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-glive-3rd-party["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "glive-3rd-party_cname" {
  count   = var.redis-glive-3rd-party["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "glive-3rd-party--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.glive-3rd-party[count.index].primary_endpoint_address]
}

###############################
# glive-gia
###############################

variable "redis-glive-gia" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "glive-gia" {
  count                         = var.redis-glive-gia["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-glive-gia,"snapshot_name","")
  snapshot_arns = lookup(var.redis-glive-gia,"snapshot_arns",null) == null ? null : split(",", var.redis-glive-gia["snapshot_arns"])
  replication_group_id          = "glive-gia-${var.env}"
  replication_group_description = var.redis-glive-gia["ticket"]
  node_type                     = var.redis-glive-gia["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "grouponlive-inventory-admin"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-glive-gia["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "glive-gia_cname" {
  count   = var.redis-glive-gia["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "glive-gia--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.glive-gia[count.index].primary_endpoint_address]
}

###############################
# glive-inventory
###############################

variable "redis-glive-inventory" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "glive-inventory" {
  count                         = var.redis-glive-inventory["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-glive-inventory,"snapshot_name","")
  snapshot_arns = lookup(var.redis-glive-inventory,"snapshot_arns",null) == null ? null : split(",", var.redis-glive-inventory["snapshot_arns"])
  replication_group_id          = "glive-inventory-${var.env}"
  replication_group_description = var.redis-glive-inventory["ticket"]
  node_type                     = var.redis-glive-inventory["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "grouponlive-inventory-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-glive-inventory["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "glive-inventory_cname" {
  count   = var.redis-glive-inventory["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "glive-inventory--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.glive-inventory[count.index].primary_endpoint_address]
}

###############################
# ttd-gia-resque
###############################

variable "redis-ttd-gia-resque" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ttd-gia-resque" {
  count                         = var.redis-ttd-gia-resque["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ttd-gia-resque,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ttd-gia-resque,"snapshot_arns",null) == null ? null : split(",", var.redis-ttd-gia-resque["snapshot_arns"])
  replication_group_id          = "ttd-gia-resque-${var.env}"
  replication_group_description = var.redis-ttd-gia-resque["ticket"]
  node_type                     = var.redis-ttd-gia-resque["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "grouponlive-inventory-admin"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ttd-gia-resque["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "ttd-gia-resque_cname" {
  count   = var.redis-ttd-gia-resque["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ttd-gia-resque--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ttd-gia-resque[count.index].primary_endpoint_address]
}

###############################
# ttd-gis-cache
###############################

variable "redis-ttd-gis-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ttd-gis-cache" {
  count                         = var.redis-ttd-gis-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = true
  snapshot_name = lookup(var.redis-ttd-gis-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ttd-gis-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-ttd-gis-cache["snapshot_arns"])
  replication_group_id          = "ttd-gis-cache-${var.env}"
  replication_group_description = var.redis-ttd-gis-cache["ticket"]
  node_type                     = var.redis-ttd-gis-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 2                                                # master + replica

  tags = {
    TenantService   = "grouponlive-inventory-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ttd-gis-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ttd-gis-cache_cname" {
  count   = var.redis-ttd-gis-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ttd-gis-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ttd-gis-cache[count.index].primary_endpoint_address]
}

###############################
# fraud-arbiter-config
###############################

variable "redis-fraud-arbiter-config" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "fraud-arbiter-config" {
  count                         = var.redis-fraud-arbiter-config["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-fraud-arbiter-config,"snapshot_name","")
  snapshot_arns = lookup(var.redis-fraud-arbiter-config,"snapshot_arns",null) == null ? null : split(",", var.redis-fraud-arbiter-config["snapshot_arns"])
  replication_group_id          = "fraud-arbiter-config-${var.env}"
  replication_group_description = var.redis-fraud-arbiter-config["ticket"]
  node_type                     = var.redis-fraud-arbiter-config["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "fraud-arbiter"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-fraud-arbiter-config["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "fraud-arbiter-config_cname" {
  count   = var.redis-fraud-arbiter-config["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "fraud-arbiter-config--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.fraud-arbiter-config[count.index].primary_endpoint_address]
}

###############################
# fraud-arbiter-cache
###############################

variable "redis-fraud-arbiter-cache" {
  type = map
  default = { create = false }
}
variable "redis_fraud_arbiter_cache_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "fraud-arbiter-cache" {
  count                         = var.redis-fraud-arbiter-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-fraud-arbiter-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-fraud-arbiter-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-fraud-arbiter-cache["snapshot_arns"])
  replication_group_id          = "fraud-arbiter-cache-${var.env}"
  replication_group_description = var.redis-fraud-arbiter-cache["ticket"]
  node_type                     = var.redis-fraud-arbiter-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_fraud_arbiter_cache_AUTH                    # bast

  tags = {
    TenantService   = "fraud-arbiter"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-fraud-arbiter-cache["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "fraud-arbiter-cache_cname" {
  count   = var.redis-fraud-arbiter-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "fraud-arbiter-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.fraud-arbiter-cache[count.index].primary_endpoint_address]
}

###############################
# fraud-arbiter-queue
###############################

variable "redis-fraud-arbiter-queue" {
  type = map
  default = { create = false }
}
variable "redis_fraud_arbiter_queue_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "fraud-arbiter-queue" {
  count                         = var.redis-fraud-arbiter-queue["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-fraud-arbiter-queue,"snapshot_name","")
  snapshot_arns = lookup(var.redis-fraud-arbiter-queue,"snapshot_arns",null) == null ? null : split(",", var.redis-fraud-arbiter-queue["snapshot_arns"])
  replication_group_id          = "fraud-arbiter-queue-${var.env}"
  replication_group_description = var.redis-fraud-arbiter-queue["ticket"]
  node_type                     = var.redis-fraud-arbiter-queue["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_fraud_arbiter_queue_AUTH                    # bast

  tags = {
    TenantService   = "fraud-arbiter"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-fraud-arbiter-queue["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "fraud-arbiter-queue_cname" {
  count   = var.redis-fraud-arbiter-queue["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "fraud-arbiter-queue--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.fraud-arbiter-queue[count.index].primary_endpoint_address]
}

###############################
# calendar-service-cache
###############################

variable "redis-calendar-service-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "calendar-service-cache" {
  count                         = var.redis-calendar-service-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-calendar-service-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-calendar-service-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-calendar-service-cache["snapshot_arns"])
  replication_group_id          = "calendar-service-cache-${var.env}"
  replication_group_description = var.redis-calendar-service-cache["ticket"]
  node_type                     = var.redis-calendar-service-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "calendar-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-calendar-service-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "calendar-service-cache_cname" {
  count   = var.redis-calendar-service-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "calendar-service-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.calendar-service-cache[count.index].primary_endpoint_address]
}

###############################
# epods
###############################

variable "redis-epods" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "epods" {
  count                         = var.redis-epods["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-epods,"snapshot_name","")
  snapshot_arns = lookup(var.redis-epods,"snapshot_arns",null) == null ? null : split(",", var.redis-epods["snapshot_arns"])
  replication_group_id          = "epods-${var.env}"
  replication_group_description = var.redis-epods["ticket"]
  node_type                     = var.redis-epods["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "epods"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-epods["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "epods_cname" {
  count   = var.redis-epods["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "epods--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.epods[count.index].primary_endpoint_address]
}

###############################
# transporter
###############################

variable "redis-transporter" {
  type = map
  default = { create = false }
}
variable "redis_transporter_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "transporter" {
  count                         = var.redis-transporter["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-transporter,"snapshot_name","")
  snapshot_arns = lookup(var.redis-transporter,"snapshot_arns",null) == null ? null : split(",", var.redis-transporter["snapshot_arns"])
  replication_group_id          = "transporter-${var.env}"
  replication_group_description = var.redis-transporter["ticket"]
  node_type                     = var.redis-transporter["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_transporter_AUTH                    # bast

  tags = {
    TenantService   = "transporter"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-transporter["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C1"
  }
}

resource "aws_route53_record" "transporter_cname" {
  count   = var.redis-transporter["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "transporter--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.transporter[count.index].primary_endpoint_address]
}

###############################
# flying-dutchman
###############################

variable "redis-flying-dutchman" {
  type = map
  default = { create = false }
}
variable "redis_flying_dutchman_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "flying-dutchman" {
  count                         = var.redis-flying-dutchman["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-flying-dutchman,"snapshot_name","")
  snapshot_arns = lookup(var.redis-flying-dutchman,"snapshot_arns",null) == null ? null : split(",", var.redis-flying-dutchman["snapshot_arns"])
  replication_group_id          = "flying-dutchman-${var.env}"
  replication_group_description = var.redis-flying-dutchman["ticket"]
  node_type                     = var.redis-flying-dutchman["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_flying_dutchman_AUTH                    # bast

  tags = {
    TenantService   = "flying_dutchman"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-flying-dutchman["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "flying-dutchman_cname" {
  count   = var.redis-flying-dutchman["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "flying-dutchman--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.flying-dutchman[count.index].primary_endpoint_address]
}

###############################
# goods-market-pricing
###############################

variable "redis-goods-market-pricing" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "goods-market-pricing" {
  count                         = var.redis-goods-market-pricing["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-goods-market-pricing,"snapshot_name","")
  snapshot_arns = lookup(var.redis-goods-market-pricing,"snapshot_arns",null) == null ? null : split(",", var.redis-goods-market-pricing["snapshot_arns"])
  replication_group_id          = "goods-market-pricing-${var.env}"
  replication_group_description = var.redis-goods-market-pricing["ticket"]
  node_type                     = var.redis-goods-market-pricing["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "goods-market-pricing"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-goods-market-pricing["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "goods-market-pricing_cname" {
  count   = var.redis-goods-market-pricing["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goods-market-pricing--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.goods-market-pricing[count.index].primary_endpoint_address]
}

###############################
# minos-cache
###############################

variable "redis-minos-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "minos-cache" {
  count                         = var.redis-minos-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-minos-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-minos-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-minos-cache["snapshot_arns"])
  replication_group_id          = "minos-cache-${var.env}"
  replication_group_description = var.redis-minos-cache["ticket"]
  node_type                     = var.redis-minos-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "minos"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-minos-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "minos-cache_cname" {
  count   = var.redis-minos-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "minos-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.minos-cache[count.index].primary_endpoint_address]
}

###############################
# mobilebot-cache
###############################

variable "redis-mobilebot-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mobilebot-cache" {
  count                         = var.redis-mobilebot-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mobilebot-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mobilebot-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-mobilebot-cache["snapshot_arns"])
  replication_group_id          = "mobilebot-cache-${var.env}"
  replication_group_description = var.redis-mobilebot-cache["ticket"]
  node_type                     = var.redis-mobilebot-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mobilebot"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mobilebot-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "mobilebot-cache_cname" {
  count   = var.redis-mobilebot-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mobilebot-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mobilebot-cache[count.index].primary_endpoint_address]
}

###############################
# offer-aggregator
###############################

variable "redis-offer-aggregator" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "offer-aggregator" {
  count                         = var.redis-offer-aggregator["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-offer-aggregator,"snapshot_name","")
  snapshot_arns = lookup(var.redis-offer-aggregator,"snapshot_arns",null) == null ? null : split(",", var.redis-offer-aggregator["snapshot_arns"])
  replication_group_id          = "offer-aggregator-${var.env}"
  replication_group_description = var.redis-offer-aggregator["ticket"]
  parameter_group_name          = var.redis-offer-aggregator["param_group"]
  node_type                     = var.redis-offer-aggregator["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "offer-aggregator-v2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-offer-aggregator["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "offer-aggregator_cname" {
  count   = var.redis-offer-aggregator["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "offer-aggregator--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.offer-aggregator[count.index].primary_endpoint_address]
}

###############################
# supply-chain-gateway-cache
###############################

variable "redis-supply-chain-gateway-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "supply-chain-gateway-cache" {
  count                         = var.redis-supply-chain-gateway-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-supply-chain-gateway-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-supply-chain-gateway-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-supply-chain-gateway-cache["snapshot_arns"])
  replication_group_id          = "supply-chain-gateway-cache-${var.env}"
  replication_group_description = var.redis-supply-chain-gateway-cache["ticket"]
  node_type                     = var.redis-supply-chain-gateway-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "supply_chain_gateway"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-supply-chain-gateway-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "supply-chain-gateway-cache_cname" {
  count   = var.redis-supply-chain-gateway-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "supply-chain-gateway-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.supply-chain-gateway-cache[count.index].primary_endpoint_address]
}

###############################
# wishlist
###############################

variable "redis-wishlist" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "wishlist" {
  count                         = var.redis-wishlist["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-wishlist,"snapshot_name","")
  snapshot_arns = lookup(var.redis-wishlist,"snapshot_arns",null) == null ? null : split(",", var.redis-wishlist["snapshot_arns"])
  replication_group_id          = "wishlist-${var.env}"
  replication_group_description = var.redis-wishlist["ticket"]
  node_type                     = var.redis-wishlist["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-wishlist["num_nodes"]
  }

  tags = {
    TenantService   = "wishlist-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-wishlist["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "wishlist_cname" {
  count   = var.redis-wishlist["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "wishlist--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.wishlist[count.index].configuration_endpoint_address]
}

###############################
# fraud
###############################

variable "redis-fraud" {
  type = map
  default = { create = false }
}
variable "redis_fraud_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "fraud" {
  count                         = var.redis-fraud["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-fraud,"snapshot_name","")
  snapshot_arns = lookup(var.redis-fraud,"snapshot_arns",null) == null ? null : split(",", var.redis-fraud["snapshot_arns"])
  replication_group_id          = "fraud-${var.env}"
  replication_group_description = var.redis-fraud["ticket"]
  node_type                     = var.redis-fraud["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_fraud_AUTH                    # bast

  tags = {
    TenantService   = "orders"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-fraud["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "fraud_cname" {
  count   = var.redis-fraud["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "fraud--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.fraud[count.index].primary_endpoint_address]
}

###############################
# orders-dashboard
###############################

variable "redis-orders-dashboard" {
  type = map
  default = { create = false }
}
variable "redis_orders_dashboard_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "orders-dashboard" {
  count                         = var.redis-orders-dashboard["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-orders-dashboard,"snapshot_name","")
  snapshot_arns = lookup(var.redis-orders-dashboard,"snapshot_arns",null) == null ? null : split(",", var.redis-orders-dashboard["snapshot_arns"])
  replication_group_id          = "orders-dashboard-${var.env}"
  replication_group_description = var.redis-orders-dashboard["ticket"]
  node_type                     = var.redis-orders-dashboard["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_orders_dashboard_AUTH                    # bast

  tags = {
    TenantService   = "orders-dashboard"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-orders-dashboard["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "orders-dashboard_cname" {
  count   = var.redis-orders-dashboard["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "orders-dashboard--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.orders-dashboard[count.index].primary_endpoint_address]
}

###############################
# orders
###############################

variable "redis-orders" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "orders" {
  count                         = var.redis-orders["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-orders,"snapshot_name","")
  snapshot_arns = lookup(var.redis-orders,"snapshot_arns",null) == null ? null : split(",", var.redis-orders["snapshot_arns"])
  replication_group_id          = "orders-${var.env}"
  replication_group_description = var.redis-orders["ticket"]
  node_type                     = var.redis-orders["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "orders"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-orders["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "orders_cname" {
  count   = var.redis-orders["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "orders--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.orders[count.index].primary_endpoint_address]
}

###############################
# orders-cloud
###############################

variable "redis-orders-cloud" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "orders-cloud" {
  count                         = var.redis-orders-cloud["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-orders-cloud,"snapshot_name","")
  snapshot_arns = lookup(var.redis-orders-cloud,"snapshot_arns",null) == null ? null : split(",", var.redis-orders-cloud["snapshot_arns"])
  replication_group_id          = "orders-cloud-${var.env}"
  replication_group_description = var.redis-orders-cloud["ticket"]
  node_type                     = var.redis-orders-cloud["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "orders"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-orders-cloud["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "orders-cloud_cname" {
  count   = var.redis-orders-cloud["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "orders-cloud--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.orders-cloud[count.index].primary_endpoint_address]
}

###############################
# orders-conveyor
###############################

variable "redis-orders-conveyor" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "orders-conveyor" {
  count                         = var.redis-orders-conveyor["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-orders-conveyor,"snapshot_name","")
  snapshot_arns = lookup(var.redis-orders-conveyor,"snapshot_arns",null) == null ? null : split(",", var.redis-orders-conveyor["snapshot_arns"])
  replication_group_id          = "orders-conveyor-${var.env}"
  replication_group_description = var.redis-orders-conveyor["ticket"]
  node_type                     = var.redis-orders-conveyor["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "orders"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-orders-conveyor["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "orders-conveyor_cname" {
  count   = var.redis-orders-conveyor["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "orders-conveyor--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.orders-conveyor[count.index].primary_endpoint_address]
}

###############################
# consumer-authority-user
###############################

variable "redis-consumer-authority-user" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "consumer-authority-user" {
  count                         = var.redis-consumer-authority-user["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-consumer-authority-user,"snapshot_name","")
  snapshot_arns = lookup(var.redis-consumer-authority-user,"snapshot_arns",null) == null ? null : split(",", var.redis-consumer-authority-user["snapshot_arns"])
  replication_group_id          = "consumer-authority-user-${var.env}"
  replication_group_description = var.redis-consumer-authority-user["ticket"]
  node_type                     = var.redis-consumer-authority-user["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_gcp_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-consumer-authority-user["num_nodes"]
  }

  tags = {
    TenantService   = "realtimeaudiencemanagementservicejtier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-consumer-authority-user["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "consumer-authority-user_cname" {
  count   = var.redis-consumer-authority-user["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "consumer-authority-user--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.consumer-authority-user[count.index].configuration_endpoint_address]
}

###############################
# sportal-cache
###############################

variable "redis-sportal-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "sportal-cache" {
  count                         = var.redis-sportal-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-sportal-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-sportal-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-sportal-cache["snapshot_arns"])
  replication_group_id          = "sportal-cache-${var.env}"
  replication_group_description = var.redis-sportal-cache["ticket"]
  node_type                     = var.redis-sportal-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "service-portal"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-sportal-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "sportal-cache_cname" {
  count   = var.redis-sportal-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "sportal-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.sportal-cache[count.index].primary_endpoint_address]
}

###############################
# sportal-cache-dev
###############################

variable "redis-sportal-cache-dev" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "sportal-cache-dev" {
  count                         = var.redis-sportal-cache-dev["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-sportal-cache-dev,"snapshot_name","")
  snapshot_arns = lookup(var.redis-sportal-cache-dev,"snapshot_arns",null) == null ? null : split(",", var.redis-sportal-cache-dev["snapshot_arns"])
  replication_group_id          = "sportal-cache-dev-${var.env}"
  replication_group_description = var.redis-sportal-cache-dev["ticket"]
  node_type                     = var.redis-sportal-cache-dev["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "service-portal"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-sportal-cache-dev["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "sportal-cache-dev_cname" {
  count   = var.redis-sportal-cache-dev["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "sportal-cache-dev--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.sportal-cache-dev[count.index].primary_endpoint_address]
}

###############################
# sportal-workers-sidekiq
###############################

variable "redis-sportal-workers-sidekiq" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "sportal-workers-sidekiq" {
  count                         = var.redis-sportal-workers-sidekiq["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-sportal-workers-sidekiq,"snapshot_name","")
  snapshot_arns = lookup(var.redis-sportal-workers-sidekiq,"snapshot_arns",null) == null ? null : split(",", var.redis-sportal-workers-sidekiq["snapshot_arns"])
  replication_group_id          = "sportal-workers-sidekiq-${var.env}"
  replication_group_description = var.redis-sportal-workers-sidekiq["ticket"]
  node_type                     = var.redis-sportal-workers-sidekiq["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "service-portal"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-sportal-workers-sidekiq["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "sportal-workers-sidekiq_cname" {
  count   = var.redis-sportal-workers-sidekiq["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "sportal-workers-sidekiq--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.sportal-workers-sidekiq[count.index].primary_endpoint_address]
}

###############################
# sportal-workers-sidekiq-dev
###############################

variable "redis-sportal-workers-sidekiq-dev" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "sportal-workers-sidekiq-dev" {
  count                         = var.redis-sportal-workers-sidekiq-dev["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-sportal-workers-sidekiq-dev,"snapshot_name","")
  snapshot_arns = lookup(var.redis-sportal-workers-sidekiq-dev,"snapshot_arns",null) == null ? null : split(",", var.redis-sportal-workers-sidekiq-dev["snapshot_arns"])
  replication_group_id          = "sportal-workers-sidekiq-dev-${var.env}"
  replication_group_description = var.redis-sportal-workers-sidekiq-dev["ticket"]
  node_type                     = var.redis-sportal-workers-sidekiq-dev["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "service-portal"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-sportal-workers-sidekiq-dev["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "sportal-workers-sidekiq-dev_cname" {
  count   = var.redis-sportal-workers-sidekiq-dev["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "sportal-workers-sidekiq-dev--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.sportal-workers-sidekiq-dev[count.index].primary_endpoint_address]
}

###############################
# getaways-inventory
###############################

variable "redis-getaways-inventory" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "getaways-inventory" {
  count                         = var.redis-getaways-inventory["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-getaways-inventory,"snapshot_name","")
  snapshot_arns = lookup(var.redis-getaways-inventory,"snapshot_arns",null) == null ? null : split(",", var.redis-getaways-inventory["snapshot_arns"])
  replication_group_id          = "getaways-inventory-${var.env}"
  replication_group_description = var.redis-getaways-inventory["ticket"]
  node_type                     = var.redis-getaways-inventory["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "getaways-inventory"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-getaways-inventory["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "getaways-inventory_cname" {
  count   = var.redis-getaways-inventory["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "getaways-inventory--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.getaways-inventory[count.index].primary_endpoint_address]
}

###############################
# getaways-inventory-product
###############################

variable "redis-getaways-inventory-product" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "getaways-inventory-product" {
  count                         = var.redis-getaways-inventory-product["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-getaways-inventory-product,"snapshot_name","")
  snapshot_arns = lookup(var.redis-getaways-inventory-product,"snapshot_arns",null) == null ? null : split(",", var.redis-getaways-inventory-product["snapshot_arns"])
  replication_group_id          = "getaways-inventory-product-${var.env}"
  replication_group_description = var.redis-getaways-inventory-product["ticket"]
  node_type                     = var.redis-getaways-inventory-product["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "getaways-inventory"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-getaways-inventory-product["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "getaways-inventory-product_cname" {
  count   = var.redis-getaways-inventory-product["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "getaways-inventory-product--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.getaways-inventory-product[count.index].primary_endpoint_address]
}

###############################
# getaways-search-cache
###############################

variable "redis-getaways-search-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "getaways-search-cache" {
  count                         = var.redis-getaways-search-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-getaways-search-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-getaways-search-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-getaways-search-cache["snapshot_arns"])
  replication_group_id          = "getaways-search-cache-${var.env}"
  replication_group_description = var.redis-getaways-search-cache["ticket"]
  node_type                     = var.redis-getaways-search-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "travel-search"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-getaways-search-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "getaways-search-cache_cname" {
  count   = var.redis-getaways-search-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "getaways-search-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.getaways-search-cache[count.index].primary_endpoint_address]
}

###############################
# lazlo-deals
###############################

variable "redis-lazlo-deals" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "lazlo-deals" {
  count                         = var.redis-lazlo-deals["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-lazlo-deals,"snapshot_name","")
  snapshot_arns = lookup(var.redis-lazlo-deals,"snapshot_arns",null) == null ? null : split(",", var.redis-lazlo-deals["snapshot_arns"])
  replication_group_id          = "lazlo-deals-${var.env}"
  replication_group_description = var.redis-lazlo-deals["ticket"]
  node_type                     = var.redis-lazlo-deals["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-lazlo-deals["num_nodes"]
  }

  tags = {
    TenantService   = "api-lazlo"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-lazlo-deals["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "lazlo-deals_cname" {
  count   = var.redis-lazlo-deals["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "lazlo-deals--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.lazlo-deals[count.index].configuration_endpoint_address]
}

###############################
# api-lazlo
###############################

variable "redis-api-lazlo" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "api-lazlo" {
  count                         = var.redis-api-lazlo["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-api-lazlo,"snapshot_name","")
  snapshot_arns = lookup(var.redis-api-lazlo,"snapshot_arns",null) == null ? null : split(",", var.redis-api-lazlo["snapshot_arns"])
  replication_group_id          = "api-lazlo-${var.env}"
  replication_group_description = var.redis-api-lazlo["ticket"]
  node_type                     = var.redis-api-lazlo["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "api-lazlo"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-api-lazlo["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "api-lazlo_cname" {
  count   = var.redis-api-lazlo["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "api-lazlo--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.api-lazlo[count.index].primary_endpoint_address]
}

###############################
# goods-stores
###############################

variable "redis-goods-stores" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "goods-stores" {
  count                         = var.redis-goods-stores["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-goods-stores,"snapshot_name","")
  snapshot_arns = lookup(var.redis-goods-stores,"snapshot_arns",null) == null ? null : split(",", var.redis-goods-stores["snapshot_arns"])
  replication_group_id          = "goods-stores-${var.env}"
  replication_group_description = var.redis-goods-stores["ticket"]
  node_type                     = var.redis-goods-stores["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "goods_stores"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-goods-stores["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "goods-stores_cname" {
  count   = var.redis-goods-stores["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "goods-stores--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.goods-stores[count.index].primary_endpoint_address]
}

###############################
# ob-3rd-party-resque
###############################

variable "redis-ob-3rd-party-resque" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ob-3rd-party-resque" {
  count                         = var.redis-ob-3rd-party-resque["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ob-3rd-party-resque,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ob-3rd-party-resque,"snapshot_arns",null) == null ? null : split(",", var.redis-ob-3rd-party-resque["snapshot_arns"])
  replication_group_id          = "ob-3rd-party-resque-${var.env}"
  replication_group_description = var.redis-ob-3rd-party-resque["ticket"]
  node_type                     = var.redis-ob-3rd-party-resque["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "online_booking_3rd_party"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ob-3rd-party-resque["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    ResqueNamespace = "3rdparty"
  }
}

resource "aws_route53_record" "ob-3rd-party-resque_cname" {
  count   = var.redis-ob-3rd-party-resque["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ob-3rd-party-resque--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ob-3rd-party-resque[count.index].primary_endpoint_address]
}

###############################
# appointments-resque
###############################

variable "redis-appointments-resque" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "appointments-resque" {
  count                         = var.redis-appointments-resque["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-appointments-resque,"snapshot_name","")
  snapshot_arns = lookup(var.redis-appointments-resque,"snapshot_arns",null) == null ? null : split(",", var.redis-appointments-resque["snapshot_arns"])
  replication_group_id          = "appointments-resque-${var.env}"
  replication_group_description = var.redis-appointments-resque["ticket"]
  node_type                     = var.redis-appointments-resque["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "appointment_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-appointments-resque["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    ResqueNamespace = "appointment_engine"
  }
}

resource "aws_route53_record" "appointments-resque_cname" {
  count   = var.redis-appointments-resque["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "appointments-resque--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.appointments-resque[count.index].primary_endpoint_address]
}

###############################
# availability-resque
###############################

variable "redis-availability-resque" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "availability-resque" {
  count                         = var.redis-availability-resque["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-availability-resque,"snapshot_name","")
  snapshot_arns = lookup(var.redis-availability-resque,"snapshot_arns",null) == null ? null : split(",", var.redis-availability-resque["snapshot_arns"])
  replication_group_id          = "availability-resque-${var.env}"
  replication_group_description = var.redis-availability-resque["ticket"]
  node_type                     = var.redis-availability-resque["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "availability_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-availability-resque["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    ResqueNamespace = "availability_engine"
  }
}

resource "aws_route53_record" "availability-resque_cname" {
  count   = var.redis-availability-resque["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "availability-resque--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.availability-resque[count.index].primary_endpoint_address]
}

###############################
# billing-record-service
###############################

variable "redis-billing-record-service" {
  type = map
  default = { create = false }
}
variable "redis_billing_record_service_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "billing-record-service" {
  count                         = var.redis-billing-record-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-billing-record-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-billing-record-service,"snapshot_arns",null) == null ? null : split(",", var.redis-billing-record-service["snapshot_arns"])
  replication_group_id          = "billing-record-service-${var.env}"
  replication_group_description = var.redis-billing-record-service["ticket"]
  node_type                     = var.redis-billing-record-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_billing_record_service_AUTH                    # bast

  tags = {
    TenantService   = "billing-record-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-billing-record-service["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "billing-record-service_cname" {
  count   = var.redis-billing-record-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "billing-record-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.billing-record-service[count.index].primary_endpoint_address]
}

###############################
# booking-engine
###############################

variable "redis-booking-engine" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "booking-engine" {
  count                         = var.redis-booking-engine["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-booking-engine,"snapshot_name","")
  snapshot_arns = lookup(var.redis-booking-engine,"snapshot_arns",null) == null ? null : split(",", var.redis-booking-engine["snapshot_arns"])
  replication_group_id          = "booking-engine-${var.env}"
  replication_group_description = var.redis-booking-engine["ticket"]
  node_type                     = var.redis-booking-engine["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "availability_engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-booking-engine["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    ResqueNamespace = "availability_engine"
  }
}

resource "aws_route53_record" "booking-engine_cname" {
  count   = var.redis-booking-engine["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "booking-engine--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.booking-engine[count.index].primary_endpoint_address]
}

###############################
# clo-service
###############################

variable "redis-clo-service" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "clo-service" {
  count                         = var.redis-clo-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-clo-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-clo-service,"snapshot_arns",null) == null ? null : split(",", var.redis-clo-service["snapshot_arns"])
  replication_group_id          = "clo-service-${var.env}"
  replication_group_description = var.redis-clo-service["ticket"]
  node_type                     = var.redis-clo-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "clo-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-clo-service["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "clo-service_cname" {
  count   = var.redis-clo-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "clo-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.clo-service[count.index].primary_endpoint_address]
}

###############################
# clo-service-jtier
###############################

variable "redis-clo-service-jtier" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "clo-service-jtier" {
  count                         = var.redis-clo-service-jtier["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-clo-service-jtier,"snapshot_name","")
  snapshot_arns = lookup(var.redis-clo-service-jtier,"snapshot_arns",null) == null ? null : split(",", var.redis-clo-service-jtier["snapshot_arns"])
  replication_group_id          = "clo-service-jtier-${var.env}"
  replication_group_description = var.redis-clo-service-jtier["ticket"]
  node_type                     = var.redis-clo-service-jtier["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "clo-inventory-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-clo-service-jtier["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "clo-service-jtier_cname" {
  count   = var.redis-clo-service-jtier["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "clo-service-jtier--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.clo-service-jtier[count.index].primary_endpoint_address]
}

###############################
# coupon
###############################

variable "redis-coupon" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "coupon" {
  count                         = var.redis-coupon["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-coupon,"snapshot_name","")
  snapshot_arns = lookup(var.redis-coupon,"snapshot_arns",null) == null ? null : split(",", var.redis-coupon["snapshot_arns"])
  replication_group_id          = "coupon-${var.env}"
  replication_group_description = var.redis-coupon["ticket"]
  node_type                     = var.redis-coupon["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "coupons_api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-coupon["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "coupon_cname" {
  count   = var.redis-coupon["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "coupon--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.coupon[count.index].primary_endpoint_address]
}

###############################
# coupon-worker
###############################

variable "redis-coupon-worker" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "coupon-worker" {
  count                         = var.redis-coupon-worker["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-coupon-worker,"snapshot_name","")
  snapshot_arns = lookup(var.redis-coupon-worker,"snapshot_arns",null) == null ? null : split(",", var.redis-coupon-worker["snapshot_arns"])
  replication_group_id          = "coupon-worker-${var.env}"
  replication_group_description = var.redis-coupon-worker["ticket"]
  node_type                     = var.redis-coupon-worker["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "coupons-revproc"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-coupon-worker["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "coupon-worker_cname" {
  count   = var.redis-coupon-worker["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "coupon-worker--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.coupon-worker[count.index].primary_endpoint_address]
}

###############################
# custsvc
###############################

variable "redis-custsvc" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "custsvc" {
  count                         = var.redis-custsvc["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-custsvc,"snapshot_name","")
  snapshot_arns = lookup(var.redis-custsvc,"snapshot_arns",null) == null ? null : split(",", var.redis-custsvc["snapshot_arns"])
  replication_group_id          = "custsvc-${var.env}"
  replication_group_description = var.redis-custsvc["ticket"]
  node_type                     = var.redis-custsvc["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "cyclops"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-custsvc["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "custsvc_cname" {
  count   = var.redis-custsvc["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "custsvc--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.custsvc[count.index].primary_endpoint_address]
}

###############################
# custsvc-cache
###############################

variable "redis-custsvc-cache" {
  type = map
  default = { create = false }
}
variable "redis_custsvc_cache_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "custsvc-cache" {
  count                         = var.redis-custsvc-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-custsvc-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-custsvc-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-custsvc-cache["snapshot_arns"])
  replication_group_id          = "custsvc-cache-${var.env}"
  replication_group_description = var.redis-custsvc-cache["ticket"]
  node_type                     = var.redis-custsvc-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_custsvc_cache_AUTH                    # bast

  tags = {
    TenantService   = "cyclops"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-custsvc-cache["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "custsvc-cache_cname" {
  count   = var.redis-custsvc-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "custsvc-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.custsvc-cache[count.index].primary_endpoint_address]
}

###############################
# custsvc-cscs
###############################

variable "redis-custsvc-cscs" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "custsvc-cscs" {
  count                         = var.redis-custsvc-cscs["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-custsvc-cscs,"snapshot_name","")
  snapshot_arns = lookup(var.redis-custsvc-cscs,"snapshot_arns",null) == null ? null : split(",", var.redis-custsvc-cscs["snapshot_arns"])
  replication_group_id          = "custsvc-cscs-${var.env}"
  replication_group_description = var.redis-custsvc-cscs["ticket"]
  node_type                     = var.redis-custsvc-cscs["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "cscs"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-custsvc-cscs["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "custsvc-cscs_cname" {
  count   = var.redis-custsvc-cscs["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "custsvc-cscs--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.custsvc-cscs[count.index].primary_endpoint_address]
}

###############################
# custsvc-cache-irb
###############################

variable "redis-custsvc-cache-irb" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "custsvc-cache-irb" {
  count                         = var.redis-custsvc-cache-irb["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-custsvc-cache-irb,"snapshot_name","")
  snapshot_arns = lookup(var.redis-custsvc-cache-irb,"snapshot_arns",null) == null ? null : split(",", var.redis-custsvc-cache-irb["snapshot_arns"])
  replication_group_id          = "custsvc-cache-irb-${var.env}"
  replication_group_description = var.redis-custsvc-cache-irb["ticket"]
  node_type                     = var.redis-custsvc-cache-irb["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "cyclops"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-custsvc-cache-irb["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "custsvc-cache-irb_cname" {
  count   = var.redis-custsvc-cache-irb["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "custsvc-cache-irb--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.custsvc-cache-irb[count.index].primary_endpoint_address]
}

###############################
# deal-management-backbeat
###############################

variable "redis-deal-management-backbeat" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "deal-management-backbeat" {
  count                         = var.redis-deal-management-backbeat["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-deal-management-backbeat,"snapshot_name","")
  snapshot_arns = lookup(var.redis-deal-management-backbeat,"snapshot_arns",null) == null ? null : split(",", var.redis-deal-management-backbeat["snapshot_arns"])
  replication_group_id          = "deal-management-backbeat-${var.env}"
  replication_group_description = var.redis-deal-management-backbeat["ticket"]
  node_type                     = var.redis-deal-management-backbeat["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal_management_api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-deal-management-backbeat["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "deal-management-backbeat_cname" {
  count   = var.redis-deal-management-backbeat["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "deal-management-backbeat--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.deal-management-backbeat[count.index].primary_endpoint_address]
}

###############################
# dealestate-configuration
###############################

variable "redis-dealestate-configuration" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dealestate-configuration" {
  count                         = var.redis-dealestate-configuration["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dealestate-configuration,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dealestate-configuration,"snapshot_arns",null) == null ? null : split(",", var.redis-dealestate-configuration["snapshot_arns"])
  replication_group_id          = "dealestate-configuration-${var.env}"
  replication_group_description = var.redis-dealestate-configuration["ticket"]
  node_type                     = var.redis-dealestate-configuration["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal-estate"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dealestate-configuration["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dealestate-configuration_cname" {
  count   = var.redis-dealestate-configuration["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dealestate-configuration--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dealestate-configuration[count.index].primary_endpoint_address]
}

###############################
# dealestate-resque
###############################

variable "redis-dealestate-resque" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dealestate-resque" {
  count                         = var.redis-dealestate-resque["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dealestate-resque,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dealestate-resque,"snapshot_arns",null) == null ? null : split(",", var.redis-dealestate-resque["snapshot_arns"])
  replication_group_id          = "dealestate-resque-${var.env}"
  replication_group_description = var.redis-dealestate-resque["ticket"]
  node_type                     = var.redis-dealestate-resque["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "deal-estate"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dealestate-resque["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "dealestate-resque_cname" {
  count   = var.redis-dealestate-resque["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dealestate-resque--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dealestate-resque[count.index].primary_endpoint_address]
}

###############################
# eds
###############################

variable "redis-eds" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "eds" {
  count                         = var.redis-eds["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-eds,"snapshot_name","")
  snapshot_arns = lookup(var.redis-eds,"snapshot_arns",null) == null ? null : split(",", var.redis-eds["snapshot_arns"])
  replication_group_id          = "eds-${var.env}"
  replication_group_description = var.redis-eds["ticket"]
  node_type                     = var.redis-eds["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "event_delivery_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-eds["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "eds_cname" {
  count   = var.redis-eds["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "eds--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.eds[count.index].primary_endpoint_address]
}

###############################
# bookingtool-cache
###############################

variable "redis-bookingtool-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "bookingtool-cache" {
  count                         = var.redis-bookingtool-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-bookingtool-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-bookingtool-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-bookingtool-cache["snapshot_arns"])
  replication_group_id          = "bookingtool-cache-${var.env}"
  replication_group_description = var.redis-bookingtool-cache["ticket"]
  node_type                     = var.redis-bookingtool-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "bookingtool"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-bookingtool-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "bookingtool-cache_cname" {
  count   = var.redis-bookingtool-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "bookingtool-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.bookingtool-cache[count.index].primary_endpoint_address]
}

###############################
# finch-cache
###############################

variable "redis-finch-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "finch-cache" {
  count                         = var.redis-finch-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-finch-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-finch-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-finch-cache["snapshot_arns"])
  replication_group_id          = "finch-cache-${var.env}"
  replication_group_description = var.redis-finch-cache["ticket"]
  node_type                     = var.redis-finch-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "birdcage"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-finch-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "finch-cache_cname" {
  count   = var.redis-finch-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "finch-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.finch-cache[count.index].primary_endpoint_address]
}

###############################
# gpapi-workers
###############################

variable "redis-gpapi-workers" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "gpapi-workers" {
  count                         = var.redis-gpapi-workers["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-gpapi-workers,"snapshot_name","")
  snapshot_arns = lookup(var.redis-gpapi-workers,"snapshot_arns",null) == null ? null : split(",", var.redis-gpapi-workers["snapshot_arns"])
  replication_group_id          = "gpapi-workers-${var.env}"
  replication_group_description = var.redis-gpapi-workers["ticket"]
  node_type                     = var.redis-gpapi-workers["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "gpapi"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-gpapi-workers["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "gpapi-workers_cname" {
  count   = var.redis-gpapi-workers["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "gpapi-workers--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.gpapi-workers[count.index].primary_endpoint_address]
}

###############################
# incentive-cache
###############################

variable "redis-incentive-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "incentive-cache" {
  count                         = var.redis-incentive-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-incentive-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-incentive-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-incentive-cache["snapshot_arns"])
  replication_group_id          = "incentive-cache-${var.env}"
  replication_group_description = var.redis-incentive-cache["ticket"]
  node_type                     = var.redis-incentive-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "incentive-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-incentive-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "incentive-cache_cname" {
  count   = var.redis-incentive-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "incentive-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.incentive-cache[count.index].primary_endpoint_address]
}

###############################
# crm-message-service
###############################

variable "redis-crm-message-service" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "crm-message-service" {
  count                         = var.redis-crm-message-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = true
  snapshot_name = lookup(var.redis-crm-message-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-crm-message-service,"snapshot_arns",null) == null ? null : split(",", var.redis-crm-message-service["snapshot_arns"])
  replication_group_id          = "crm-message-service-${var.env}"
  replication_group_description = var.redis-crm-message-service["ticket"]
  node_type                     = var.redis-crm-message-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 2                                                # master + replica

  tags = {
    TenantService   = "crm-message-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-crm-message-service["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "crm-message-service_cname" {
  count   = var.redis-crm-message-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "crm-message-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.crm-message-service[count.index].primary_endpoint_address]
}

###############################
# ingestion-cache
###############################

variable "redis-ingestion-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ingestion-cache" {
  count                         = var.redis-ingestion-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ingestion-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ingestion-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-ingestion-cache["snapshot_arns"])
  replication_group_id          = "ingestion-cache-${var.env}"
  replication_group_description = var.redis-ingestion-cache["ticket"]
  node_type                     = var.redis-ingestion-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "ingestion-jtier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ingestion-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ingestion-cache_cname" {
  count   = var.redis-ingestion-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ingestion-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ingestion-cache[count.index].primary_endpoint_address]
}

###############################
# ipam1
###############################

variable "redis-ipam1" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ipam1" {
  count                         = var.redis-ipam1["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ipam1,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ipam1,"snapshot_arns",null) == null ? null : split(",", var.redis-ipam1["snapshot_arns"])
  replication_group_id          = "ipam1-${var.env}"
  replication_group_description = var.redis-ipam1["ticket"]
  node_type                     = var.redis-ipam1["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "network"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ipam1["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ipam1_cname" {
  count   = var.redis-ipam1["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ipam1--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ipam1[count.index].primary_endpoint_address]
}

###############################
# ipam
###############################

variable "redis-ipam" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ipam" {
  count                         = var.redis-ipam["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ipam,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ipam,"snapshot_arns",null) == null ? null : split(",", var.redis-ipam["snapshot_arns"])
  replication_group_id          = "ipam-${var.env}"
  replication_group_description = var.redis-ipam["ticket"]
  node_type                     = var.redis-ipam["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "network"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ipam["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ipam_cname" {
  count   = var.redis-ipam["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ipam--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ipam[count.index].primary_endpoint_address]
}

###############################
# killbill
###############################

variable "redis-killbill" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "killbill" {
  count                         = var.redis-killbill["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-killbill,"snapshot_name","")
  snapshot_arns = lookup(var.redis-killbill,"snapshot_arns",null) == null ? null : split(",", var.redis-killbill["snapshot_arns"])
  replication_group_id          = "killbill-${var.env}"
  replication_group_description = var.redis-killbill["ticket"]
  node_type                     = var.redis-killbill["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "killbill-payments"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-killbill["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "killbill_cname" {
  count   = var.redis-killbill["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "killbill--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.killbill[count.index].primary_endpoint_address]
}

###############################
# mds
###############################

variable "redis-mds" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mds" {
  count                         = var.redis-mds["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mds,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mds,"snapshot_arns",null) == null ? null : split(",", var.redis-mds["snapshot_arns"])
  replication_group_id          = "mds-${var.env}"
  replication_group_description = var.redis-mds["ticket"]
  node_type                     = var.redis-mds["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_dnd_account_sg[0].id, aws_security_group.raas_allow_gcp_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "marketing-deal-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mds["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "mds_cname" {
  count   = var.redis-mds["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mds--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mds[count.index].primary_endpoint_address]
}

###############################
# merchant-self-service-engine
###############################

variable "redis-merchant-self-service-engine" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "merchant-self-service-engine" {
  count                         = var.redis-merchant-self-service-engine["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-merchant-self-service-engine,"snapshot_name","")
  snapshot_arns = lookup(var.redis-merchant-self-service-engine,"snapshot_arns",null) == null ? null : split(",", var.redis-merchant-self-service-engine["snapshot_arns"])
  replication_group_id          = "merchant-self-service-engine-${var.env}"
  replication_group_description = var.redis-merchant-self-service-engine["ticket"]
  node_type                     = var.redis-merchant-self-service-engine["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "self-services-service-engine"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-merchant-self-service-engine["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "merchant-self-service-engine_cname" {
  count   = var.redis-merchant-self-service-engine["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "merchant-self-service-engine--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.merchant-self-service-engine[count.index].primary_endpoint_address]
}

###############################
# mppservice-cache
###############################

variable "redis-mppservice-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mppservice-cache" {
  count                         = var.redis-mppservice-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mppservice-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mppservice-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-mppservice-cache["snapshot_arns"])
  replication_group_id          = "mppservice-cache-${var.env}"
  replication_group_description = var.redis-mppservice-cache["ticket"]
  node_type                     = var.redis-mppservice-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mpp-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mppservice-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "mppservice-cache_cname" {
  count   = var.redis-mppservice-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mppservice-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mppservice-cache[count.index].primary_endpoint_address]
}

###############################
# rise
###############################

variable "redis-rise" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rise" {
  count                         = var.redis-rise["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rise,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rise,"snapshot_arns",null) == null ? null : split(",", var.redis-rise["snapshot_arns"])
  replication_group_id          = "rise-${var.env}"
  replication_group_description = var.redis-rise["ticket"]
  node_type                     = var.redis-rise["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "rise"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rise["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "rise_cname" {
  count   = var.redis-rise["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rise--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rise[count.index].primary_endpoint_address]
}

###############################
# social-raf
###############################

variable "redis-social-raf" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "social-raf" {
  count                         = var.redis-social-raf["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-social-raf,"snapshot_name","")
  snapshot_arns = lookup(var.redis-social-raf,"snapshot_arns",null) == null ? null : split(",", var.redis-social-raf["snapshot_arns"])
  replication_group_id          = "social-raf-${var.env}"
  replication_group_description = var.redis-social-raf["ticket"]
  node_type                     = var.redis-social-raf["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raf"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-social-raf["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "social-raf_cname" {
  count   = var.redis-social-raf["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "social-raf--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.social-raf[count.index].primary_endpoint_address]
}

###############################
# ticketsvc
###############################

variable "redis-ticketsvc" {
  type = map
  default = { create = false }
}
variable "redis_ticketsvc_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "ticketsvc" {
  count                         = var.redis-ticketsvc["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ticketsvc,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ticketsvc,"snapshot_arns",null) == null ? null : split(",", var.redis-ticketsvc["snapshot_arns"])
  replication_group_id          = "ticketsvc-${var.env}"
  replication_group_description = var.redis-ticketsvc["ticket"]
  node_type                     = var.redis-ticketsvc["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_ticketsvc_AUTH                    # bast

  tags = {
    TenantService   = "ticketing_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ticketsvc["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "ticketsvc_cname" {
  count   = var.redis-ticketsvc["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ticketsvc--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ticketsvc[count.index].primary_endpoint_address]
}

###############################
# users-service
###############################

variable "redis-users-service" {
  type = map
  default = { create = false }
}
variable "redis_users_service_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "users-service" {
  count                         = var.redis-users-service["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-users-service,"snapshot_name","")
  snapshot_arns = lookup(var.redis-users-service,"snapshot_arns",null) == null ? null : split(",", var.redis-users-service["snapshot_arns"])
  replication_group_id          = "users-service-${var.env}"
  replication_group_description = var.redis-users-service["ticket"]
  node_type                     = var.redis-users-service["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_users_service_AUTH                    # bast

  tags = {
    TenantService   = "users-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-users-service["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "users-service_cname" {
  count   = var.redis-users-service["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "users-service--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.users-service[count.index].primary_endpoint_address]
}

###############################
# voucher-inventory
###############################

variable "redis-voucher-inventory" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "voucher-inventory" {
  count                         = var.redis-voucher-inventory["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-voucher-inventory,"snapshot_name","")
  snapshot_arns = lookup(var.redis-voucher-inventory,"snapshot_arns",null) == null ? null : split(",", var.redis-voucher-inventory["snapshot_arns"])
  replication_group_id          = "voucher-inventory-${var.env}"
  replication_group_description = var.redis-voucher-inventory["ticket"]
  node_type                     = var.redis-voucher-inventory["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "voucher-inventory"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-voucher-inventory["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "voucher-inventory_cname" {
  count   = var.redis-voucher-inventory["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "voucher-inventory--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.voucher-inventory[count.index].primary_endpoint_address]
}

###############################
# ugc
###############################

variable "redis-ugc" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ugc" {
  count                         = var.redis-ugc["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ugc,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ugc,"snapshot_arns",null) == null ? null : split(",", var.redis-ugc["snapshot_arns"])
  replication_group_id          = "ugc-${var.env}"
  replication_group_description = var.redis-ugc["ticket"]
  node_type                     = var.redis-ugc["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "ugc-api-jtier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ugc["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ugc_cname" {
  count   = var.redis-ugc["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ugc--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ugc[count.index].primary_endpoint_address]
}

###############################
# ugc2
###############################

variable "redis-ugc2" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ugc2" {
  count                         = var.redis-ugc2["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ugc2,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ugc2,"snapshot_arns",null) == null ? null : split(",", var.redis-ugc2["snapshot_arns"])
  replication_group_id          = "ugc2-${var.env}"
  replication_group_description = var.redis-ugc2["ticket"]
  node_type                     = var.redis-ugc2["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-ugc2["num_nodes"]
  }

  tags = {
    TenantService   = "ugc-api-jtier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ugc2["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ugc2_cname" {
  count   = var.redis-ugc2["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ugc2--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ugc2[count.index].configuration_endpoint_address]
}

###############################
# ugc-cache
###############################

variable "redis-ugc-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "ugc-cache" {
  count                         = var.redis-ugc-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-ugc-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-ugc-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-ugc-cache["snapshot_arns"])
  replication_group_id          = "ugc-cache-${var.env}"
  replication_group_description = var.redis-ugc-cache["ticket"]
  node_type                     = var.redis-ugc-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-ugc-cache["num_nodes"]
  }

  tags = {
    TenantService   = "ugc-api-jtier"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-ugc-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "ugc-cache_cname" {
  count   = var.redis-ugc-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "ugc-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.ugc-cache[count.index].configuration_endpoint_address]
}

###############################
# coupons-inventory
###############################

variable "redis-coupons-inventory" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "coupons-inventory" {
  count                         = var.redis-coupons-inventory["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-coupons-inventory,"snapshot_name","")
  snapshot_arns = lookup(var.redis-coupons-inventory,"snapshot_arns",null) == null ? null : split(",", var.redis-coupons-inventory["snapshot_arns"])
  replication_group_id          = "coupons-inventory-${var.env}"
  replication_group_description = var.redis-coupons-inventory["ticket"]
  node_type                     = var.redis-coupons-inventory["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "coupons-inventory-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-coupons-inventory["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "coupons-inventory_cname" {
  count   = var.redis-coupons-inventory["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "coupons-inventory--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.coupons-inventory[count.index].primary_endpoint_address]
}

###############################
# watson-user-kv
###############################

variable "redis-watson-user-kv" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "watson-user-kv" {
  count                         = var.redis-watson-user-kv["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-watson-user-kv,"snapshot_name","")
  snapshot_arns = lookup(var.redis-watson-user-kv,"snapshot_arns",null) == null ? null : split(",", var.redis-watson-user-kv["snapshot_arns"])
  replication_group_id          = "watson-user-kv-${var.env}"
  replication_group_description = var.redis-watson-user-kv["ticket"]
  node_type                     = var.redis-watson-user-kv["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_dnd_account_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-watson-user-kv["num_nodes"]
  }

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-watson-user-kv["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "watson-user-kv_cname" {
  count   = var.redis-watson-user-kv["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "watson-user-kv--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.watson-user-kv[count.index].configuration_endpoint_address]
}

###############################
# watson-deal-kv
###############################

variable "redis-watson-deal-kv" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "watson-deal-kv" {
  count                         = var.redis-watson-deal-kv["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-watson-deal-kv,"snapshot_name","")
  snapshot_arns = lookup(var.redis-watson-deal-kv,"snapshot_arns",null) == null ? null : split(",", var.redis-watson-deal-kv["snapshot_arns"])
  replication_group_id          = "watson-deal-kv-${var.env}"
  replication_group_description = var.redis-watson-deal-kv["ticket"]
  node_type                     = var.redis-watson-deal-kv["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-watson-deal-kv["num_nodes"]
  }

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-watson-deal-kv["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "watson-deal-kv_cname" {
  count   = var.redis-watson-deal-kv["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "watson-deal-kv--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.watson-deal-kv[count.index].configuration_endpoint_address]
}

###############################
# watson-freshness
###############################

variable "redis-watson-freshness" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "watson-freshness" {
  count                         = var.redis-watson-freshness["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-watson-freshness,"snapshot_name","")
  snapshot_arns = lookup(var.redis-watson-freshness,"snapshot_arns",null) == null ? null : split(",", var.redis-watson-freshness["snapshot_arns"])
  replication_group_id          = "watson-freshness-${var.env}"
  replication_group_description = var.redis-watson-freshness["ticket"]
  node_type                     = var.redis-watson-freshness["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_dnd_account_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-watson-freshness["num_nodes"]
  }

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-watson-freshness["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "watson-freshness_cname" {
  count   = var.redis-watson-freshness["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "watson-freshness--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.watson-freshness[count.index].configuration_endpoint_address]
}

resource "aws_appautoscaling_target" "watson-freshness-autoscaling-nodes-target" {
  count   = var.redis-watson-freshness["create"] ? 1 : 0
  min_capacity       = var.redis-watson-freshness["autoscaling_min_nodes"]
  max_capacity       = var.redis-watson-freshness["autoscaling_max_nodes"]
  resource_id        = "replication-group/${aws_elasticache_replication_group.watson-freshness[count.index].id}"
  scalable_dimension = "elasticache:replication-group:NodeGroups"
  service_namespace  = "elasticache"
}

resource "aws_appautoscaling_policy" "watson-freshness-autoscaling-policy" {
  count   = var.redis-watson-freshness["create"] ? 1 : 0
  name               = "watson-freshness-autoscaling-mem-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.watson-freshness-autoscaling-nodes-target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.watson-freshness-autoscaling-nodes-target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.watson-freshness-autoscaling-nodes-target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ElastiCacheDatabaseMemoryUsageCountedForEvictPercentage"
    }
    target_value = var.redis-watson-freshness["autoscaling_mem_target"]
  }
}

###############################
# watson-search-kv
###############################

variable "redis-watson-search-kv" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "watson-search-kv" {
  count                         = var.redis-watson-search-kv["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-watson-search-kv,"snapshot_name","")
  snapshot_arns = lookup(var.redis-watson-search-kv,"snapshot_arns",null) == null ? null : split(",", var.redis-watson-search-kv["snapshot_arns"])
  replication_group_id          = "watson-search-kv-${var.env}"
  replication_group_description = var.redis-watson-search-kv["ticket"]
  node_type                     = var.redis-watson-search-kv["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_dnd_account_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-watson-search-kv["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "watson-search-kv_cname" {
  count   = var.redis-watson-search-kv["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "watson-search-kv--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.watson-search-kv[count.index].primary_endpoint_address]
}

###############################
# holmes-lovo-rvd
###############################

variable "redis-holmes-lovo-rvd" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-lovo-rvd" {
  count                         = var.redis-holmes-lovo-rvd["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-lovo-rvd,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-lovo-rvd,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-lovo-rvd["snapshot_arns"])
  replication_group_id          = "holmes-lovo-rvd-${var.env}"
  replication_group_description = var.redis-holmes-lovo-rvd["ticket"]
  node_type                     = var.redis-holmes-lovo-rvd["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-lovo-rvd["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-lovo-rvd_cname" {
  count   = var.redis-holmes-lovo-rvd["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-lovo-rvd--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-lovo-rvd[count.index].primary_endpoint_address]
}

###############################
# holmes-user-identities
###############################

variable "redis-holmes-user-identities" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-user-identities" {
  count                         = var.redis-holmes-user-identities["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-user-identities,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-user-identities,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-user-identities["snapshot_arns"])
  replication_group_id          = "holmes-user-identities-${var.env}"
  replication_group_description = var.redis-holmes-user-identities["ticket"]
  node_type                     = var.redis-holmes-user-identities["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-user-identities["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-user-identities_cname" {
  count   = var.redis-holmes-user-identities["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-user-identities--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-user-identities[count.index].primary_endpoint_address]
}

###############################
# holmes-user-recent-searches
###############################

variable "redis-holmes-user-recent-searches" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-user-recent-searches" {
  count                         = var.redis-holmes-user-recent-searches["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-user-recent-searches,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-user-recent-searches,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-user-recent-searches["snapshot_arns"])
  replication_group_id          = "holmes-user-recent-searches-${var.env}"
  replication_group_description = var.redis-holmes-user-recent-searches["ticket"]
  node_type                     = var.redis-holmes-user-recent-searches["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-user-recent-searches["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-user-recent-searches_cname" {
  count   = var.redis-holmes-user-recent-searches["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-user-recent-searches--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-user-recent-searches[count.index].primary_endpoint_address]
}

###############################
# holmes-user-search-personalize
###############################

variable "redis-holmes-user-search-personalize" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-user-search-personalize" {
  count                         = var.redis-holmes-user-search-personalize["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-user-search-personalize,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-user-search-personalize,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-user-search-personalize["snapshot_arns"])
  replication_group_id          = "holmes-user-search-personalize-${var.env}"
  replication_group_description = var.redis-holmes-user-search-personalize["ticket"]
  parameter_group_name          = var.redis-holmes-user-search-personalize["param_group"]
  node_type                     = var.redis-holmes-user-search-personalize["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-user-search-personalize["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-user-search-personalize_cname" {
  count   = var.redis-holmes-user-search-personalize["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-user-search-personalize--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-user-search-personalize[count.index].primary_endpoint_address]
}

###############################
# holmes-user-rt-search-eng
###############################

variable "redis-holmes-user-rt-search-eng" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-user-rt-search-eng" {
  count                         = var.redis-holmes-user-rt-search-eng["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-user-rt-search-eng,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-user-rt-search-eng,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-user-rt-search-eng["snapshot_arns"])
  replication_group_id          = "holmes-user-rt-search-eng-${var.env}"
  replication_group_description = var.redis-holmes-user-rt-search-eng["ticket"]
  node_type                     = var.redis-holmes-user-rt-search-eng["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "holmes-feature-platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-user-rt-search-eng["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-user-rt-search-eng_cname" {
  count   = var.redis-holmes-user-rt-search-eng["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-user-rt-search-eng--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-user-rt-search-eng[count.index].primary_endpoint_address]
}

###############################
# holmes-deal-rt-loci
###############################

variable "redis-holmes-deal-rt-loci" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-deal-rt-loci" {
  count                         = var.redis-holmes-deal-rt-loci["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-deal-rt-loci,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-deal-rt-loci,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-deal-rt-loci["snapshot_arns"])
  replication_group_id          = "holmes-deal-rt-loci-${var.env}"
  replication_group_description = var.redis-holmes-deal-rt-loci["ticket"]
  node_type                     = var.redis-holmes-deal-rt-loci["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "holmes-feature-platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-deal-rt-loci["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-deal-rt-loci_cname" {
  count   = var.redis-holmes-deal-rt-loci["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-deal-rt-loci--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-deal-rt-loci[count.index].primary_endpoint_address]
}

###############################
# holmes-deal-rt-goods
###############################

variable "redis-holmes-deal-rt-goods" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-deal-rt-goods" {
  count                         = var.redis-holmes-deal-rt-goods["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-deal-rt-goods,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-deal-rt-goods,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-deal-rt-goods["snapshot_arns"])
  replication_group_id          = "holmes-deal-rt-goods-${var.env}"
  replication_group_description = var.redis-holmes-deal-rt-goods["ticket"]
  node_type                     = var.redis-holmes-deal-rt-goods["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "holmes-feature-platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-deal-rt-goods["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-deal-rt-goods_cname" {
  count   = var.redis-holmes-deal-rt-goods["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-deal-rt-goods--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-deal-rt-goods[count.index].primary_endpoint_address]
}

###############################
# holmes-user-rt-marketing
###############################

variable "redis-holmes-user-rt-marketing" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-user-rt-marketing" {
  count                         = var.redis-holmes-user-rt-marketing["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-user-rt-marketing,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-user-rt-marketing,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-user-rt-marketing["snapshot_arns"])
  replication_group_id          = "holmes-user-rt-marketing-${var.env}"
  replication_group_description = var.redis-holmes-user-rt-marketing["ticket"]
  node_type                     = var.redis-holmes-user-rt-marketing["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "holmes-feature-platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-user-rt-marketing["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-user-rt-marketing_cname" {
  count   = var.redis-holmes-user-rt-marketing["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-user-rt-marketing--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-user-rt-marketing[count.index].primary_endpoint_address]
}

###############################
# holmes-deals-rt-core-ranking
###############################

variable "redis-holmes-deals-rt-core-ranking" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-deals-rt-core-ranking" {
  count                         = var.redis-holmes-deals-rt-core-ranking["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-deals-rt-core-ranking,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-deals-rt-core-ranking,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-deals-rt-core-ranking["snapshot_arns"])
  replication_group_id          = "holmes-deals-rt-core-ranking-${var.env}"
  replication_group_description = var.redis-holmes-deals-rt-core-ranking["ticket"]
  node_type                     = var.redis-holmes-deals-rt-core-ranking["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "holmes-feature-platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-deals-rt-core-ranking["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-deals-rt-core-ranking_cname" {
  count   = var.redis-holmes-deals-rt-core-ranking["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-deals-rt-core-ranking--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-deals-rt-core-ranking[count.index].primary_endpoint_address]
}

###############################
# holmes-deals-rt-dsp
###############################

variable "redis-holmes-deals-rt-dsp" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "holmes-deals-rt-dsp" {
  count                         = var.redis-holmes-deals-rt-dsp["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-holmes-deals-rt-dsp,"snapshot_name","")
  snapshot_arns = lookup(var.redis-holmes-deals-rt-dsp,"snapshot_arns",null) == null ? null : split(",", var.redis-holmes-deals-rt-dsp["snapshot_arns"])
  replication_group_id          = "holmes-deals-rt-dsp-${var.env}"
  replication_group_description = var.redis-holmes-deals-rt-dsp["ticket"]
  node_type                     = var.redis-holmes-deals-rt-dsp["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "holmes-feature-platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-holmes-deals-rt-dsp["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "holmes-deals-rt-dsp_cname" {
  count   = var.redis-holmes-deals-rt-dsp["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "holmes-deals-rt-dsp--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.holmes-deals-rt-dsp[count.index].primary_endpoint_address]
}

###############################
# janus00
###############################

variable "redis-janus00" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus00" {
  count                         = var.redis-janus00["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus00,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus00,"snapshot_arns",null) == null ? null : split(",", var.redis-janus00["snapshot_arns"])
  replication_group_id          = "janus00-${var.env}"
  replication_group_description = var.redis-janus00["ticket"]
  node_type                     = var.redis-janus00["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus00["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus00_cname" {
  count   = var.redis-janus00["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus00--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus00[count.index].primary_endpoint_address]
}

###############################
# janus01
###############################

variable "redis-janus01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus01" {
  count                         = var.redis-janus01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus01,"snapshot_arns",null) == null ? null : split(",", var.redis-janus01["snapshot_arns"])
  replication_group_id          = "janus01-${var.env}"
  replication_group_description = var.redis-janus01["ticket"]
  node_type                     = var.redis-janus01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus01["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus01_cname" {
  count   = var.redis-janus01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus01[count.index].primary_endpoint_address]
}

###############################
# janus02
###############################

variable "redis-janus02" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus02" {
  count                         = var.redis-janus02["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus02,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus02,"snapshot_arns",null) == null ? null : split(",", var.redis-janus02["snapshot_arns"])
  replication_group_id          = "janus02-${var.env}"
  replication_group_description = var.redis-janus02["ticket"]
  node_type                     = var.redis-janus02["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus02["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus02_cname" {
  count   = var.redis-janus02["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus02--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus02[count.index].primary_endpoint_address]
}

###############################
# janus03
###############################

variable "redis-janus03" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus03" {
  count                         = var.redis-janus03["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus03,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus03,"snapshot_arns",null) == null ? null : split(",", var.redis-janus03["snapshot_arns"])
  replication_group_id          = "janus03-${var.env}"
  replication_group_description = var.redis-janus03["ticket"]
  node_type                     = var.redis-janus03["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus03["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus03_cname" {
  count   = var.redis-janus03["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus03--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus03[count.index].primary_endpoint_address]
}

###############################
# janus04
###############################

variable "redis-janus04" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus04" {
  count                         = var.redis-janus04["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus04,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus04,"snapshot_arns",null) == null ? null : split(",", var.redis-janus04["snapshot_arns"])
  replication_group_id          = "janus04-${var.env}"
  replication_group_description = var.redis-janus04["ticket"]
  node_type                     = var.redis-janus04["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus04["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus04_cname" {
  count   = var.redis-janus04["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus04--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus04[count.index].primary_endpoint_address]
}

###############################
# janus05
###############################

variable "redis-janus05" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus05" {
  count                         = var.redis-janus05["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus05,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus05,"snapshot_arns",null) == null ? null : split(",", var.redis-janus05["snapshot_arns"])
  replication_group_id          = "janus05-${var.env}"
  replication_group_description = var.redis-janus05["ticket"]
  node_type                     = var.redis-janus05["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus05["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus05_cname" {
  count   = var.redis-janus05["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus05--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus05[count.index].primary_endpoint_address]
}

###############################
# janus06
###############################

variable "redis-janus06" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus06" {
  count                         = var.redis-janus06["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus06,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus06,"snapshot_arns",null) == null ? null : split(",", var.redis-janus06["snapshot_arns"])
  replication_group_id          = "janus06-${var.env}"
  replication_group_description = var.redis-janus06["ticket"]
  node_type                     = var.redis-janus06["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus06["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus06_cname" {
  count   = var.redis-janus06["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus06--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus06[count.index].primary_endpoint_address]
}

###############################
# janus07
###############################

variable "redis-janus07" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus07" {
  count                         = var.redis-janus07["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus07,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus07,"snapshot_arns",null) == null ? null : split(",", var.redis-janus07["snapshot_arns"])
  replication_group_id          = "janus07-${var.env}"
  replication_group_description = var.redis-janus07["ticket"]
  node_type                     = var.redis-janus07["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus07["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus07_cname" {
  count   = var.redis-janus07["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus07--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus07[count.index].primary_endpoint_address]
}

###############################
# janus08
###############################

variable "redis-janus08" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus08" {
  count                         = var.redis-janus08["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus08,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus08,"snapshot_arns",null) == null ? null : split(",", var.redis-janus08["snapshot_arns"])
  replication_group_id          = "janus08-${var.env}"
  replication_group_description = var.redis-janus08["ticket"]
  node_type                     = var.redis-janus08["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus08["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus08_cname" {
  count   = var.redis-janus08["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus08--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus08[count.index].primary_endpoint_address]
}

###############################
# janus09
###############################

variable "redis-janus09" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus09" {
  count                         = var.redis-janus09["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus09,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus09,"snapshot_arns",null) == null ? null : split(",", var.redis-janus09["snapshot_arns"])
  replication_group_id          = "janus09-${var.env}"
  replication_group_description = var.redis-janus09["ticket"]
  node_type                     = var.redis-janus09["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus09["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus09_cname" {
  count   = var.redis-janus09["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus09--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus09[count.index].primary_endpoint_address]
}

###############################
# janus10
###############################

variable "redis-janus10" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus10" {
  count                         = var.redis-janus10["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus10,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus10,"snapshot_arns",null) == null ? null : split(",", var.redis-janus10["snapshot_arns"])
  replication_group_id          = "janus10-${var.env}"
  replication_group_description = var.redis-janus10["ticket"]
  node_type                     = var.redis-janus10["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus10["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus10_cname" {
  count   = var.redis-janus10["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus10--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus10[count.index].primary_endpoint_address]
}

###############################
# janus11
###############################

variable "redis-janus11" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus11" {
  count                         = var.redis-janus11["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus11,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus11,"snapshot_arns",null) == null ? null : split(",", var.redis-janus11["snapshot_arns"])
  replication_group_id          = "janus11-${var.env}"
  replication_group_description = var.redis-janus11["ticket"]
  node_type                     = var.redis-janus11["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus11["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus11_cname" {
  count   = var.redis-janus11["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus11--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus11[count.index].primary_endpoint_address]
}

###############################
# janus12
###############################

variable "redis-janus12" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus12" {
  count                         = var.redis-janus12["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus12,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus12,"snapshot_arns",null) == null ? null : split(",", var.redis-janus12["snapshot_arns"])
  replication_group_id          = "janus12-${var.env}"
  replication_group_description = var.redis-janus12["ticket"]
  node_type                     = var.redis-janus12["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus12["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus12_cname" {
  count   = var.redis-janus12["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus12--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus12[count.index].primary_endpoint_address]
}

###############################
# janus13
###############################

variable "redis-janus13" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus13" {
  count                         = var.redis-janus13["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus13,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus13,"snapshot_arns",null) == null ? null : split(",", var.redis-janus13["snapshot_arns"])
  replication_group_id          = "janus13-${var.env}"
  replication_group_description = var.redis-janus13["ticket"]
  node_type                     = var.redis-janus13["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus13["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus13_cname" {
  count   = var.redis-janus13["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus13--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus13[count.index].primary_endpoint_address]
}

###############################
# janus14
###############################

variable "redis-janus14" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus14" {
  count                         = var.redis-janus14["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus14,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus14,"snapshot_arns",null) == null ? null : split(",", var.redis-janus14["snapshot_arns"])
  replication_group_id          = "janus14-${var.env}"
  replication_group_description = var.redis-janus14["ticket"]
  node_type                     = var.redis-janus14["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus14["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus14_cname" {
  count   = var.redis-janus14["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus14--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus14[count.index].primary_endpoint_address]
}

###############################
# janus15
###############################

variable "redis-janus15" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus15" {
  count                         = var.redis-janus15["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus15,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus15,"snapshot_arns",null) == null ? null : split(",", var.redis-janus15["snapshot_arns"])
  replication_group_id          = "janus15-${var.env}"
  replication_group_description = var.redis-janus15["ticket"]
  node_type                     = var.redis-janus15["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus15["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus15_cname" {
  count   = var.redis-janus15["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus15--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus15[count.index].primary_endpoint_address]
}

###############################
# rm-cache
###############################

variable "redis-rm-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rm-cache" {
  count                         = var.redis-rm-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rm-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rm-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-rm-cache["snapshot_arns"])
  replication_group_id          = "rm-cache-${var.env}"
  replication_group_description = var.redis-rm-cache["ticket"]
  node_type                     = var.redis-rm-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rm-cache["num_nodes"]
  }

  tags = {
    TenantService   = "rocketman_v2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rm-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rm-cache_cname" {
  count   = var.redis-rm-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rm-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rm-cache[count.index].configuration_endpoint_address]
}

###############################
# rm-error-handling
###############################

variable "redis-rm-error-handling" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rm-error-handling" {
  count                         = var.redis-rm-error-handling["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rm-error-handling,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rm-error-handling,"snapshot_arns",null) == null ? null : split(",", var.redis-rm-error-handling["snapshot_arns"])
  replication_group_id          = "rm-error-handling-${var.env}"
  replication_group_description = var.redis-rm-error-handling["ticket"]
  parameter_group_name          = aws_elasticache_parameter_group.raas-redis6-rm-error-handling[count.index].id
  node_type                     = var.redis-rm-error-handling["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rm-error-handling["num_nodes"]
  }

  tags = {
    TenantService   = "rocketman_v2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rm-error-handling["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "rm-error-handling_cname" {
  count   = var.redis-rm-error-handling["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rm-error-handling--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rm-error-handling[count.index].configuration_endpoint_address]
}

resource "aws_elasticache_parameter_group" "raas-redis6-rm-error-handling" {
  count   = var.redis-rm-error-handling["create"] ? 1 : 0
  name   = "raas-redis6-rm-error-handling"
  family = "redis6.x"

  parameter {
    name  = "cluster-enabled"
    value = "yes"
  }
  parameter {
    name  = "maxmemory-policy"
    value = var.redis-rm-error-handling["maxmemory-policy"]
  }
}

###############################
# rm-state-tracking
###############################

variable "redis-rm-state-tracking" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rm-state-tracking" {
  count                         = var.redis-rm-state-tracking["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rm-state-tracking,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rm-state-tracking,"snapshot_arns",null) == null ? null : split(",", var.redis-rm-state-tracking["snapshot_arns"])
  replication_group_id          = "rm-state-tracking-${var.env}"
  replication_group_description = var.redis-rm-state-tracking["ticket"]
  node_type                     = var.redis-rm-state-tracking["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-rm-state-tracking["num_nodes"]
  }

  tags = {
    TenantService   = "rocketman_v2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rm-state-tracking["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rm-state-tracking_cname" {
  count   = var.redis-rm-state-tracking["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rm-state-tracking--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rm-state-tracking[count.index].configuration_endpoint_address]
}

###############################
# rm-user-resque
###############################

variable "redis-rm-user-resque" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rm-user-resque" {
  count                         = var.redis-rm-user-resque["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rm-user-resque,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rm-user-resque,"snapshot_arns",null) == null ? null : split(",", var.redis-rm-user-resque["snapshot_arns"])
  replication_group_id          = "rm-user-resque-${var.env}"
  replication_group_description = var.redis-rm-user-resque["ticket"]
  node_type                     = var.redis-rm-user-resque["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "rocketman_v2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rm-user-resque["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rm-user-resque_cname" {
  count   = var.redis-rm-user-resque["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rm-user-resque--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rm-user-resque[count.index].primary_endpoint_address]
}

###############################
# cs-api-cache
###############################

variable "redis-cs-api-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "cs-api-cache" {
  count                         = var.redis-cs-api-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-cs-api-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-cs-api-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-cs-api-cache["snapshot_arns"])
  replication_group_id          = "cs-api-cache-${var.env}"
  replication_group_description = var.redis-cs-api-cache["ticket"]
  node_type                     = var.redis-cs-api-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "cs-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-cs-api-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "cs-api-cache_cname" {
  count   = var.redis-cs-api-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "cs-api-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.cs-api-cache[count.index].primary_endpoint_address]
}

###############################
# janus-bcookie
###############################

variable "redis-janus-bcookie" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "janus-bcookie" {
  count                         = var.redis-janus-bcookie["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-janus-bcookie,"snapshot_name","")
  snapshot_arns = lookup(var.redis-janus-bcookie,"snapshot_arns",null) == null ? null : split(",", var.redis-janus-bcookie["snapshot_arns"])
  replication_group_id          = "janus-bcookie-${var.env}"
  replication_group_description = var.redis-janus-bcookie["ticket"]
  node_type                     = var.redis-janus-bcookie["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-janus-bcookie["num_nodes"]
  }

  tags = {
    TenantService   = "janus"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-janus-bcookie["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "janus-bcookie_cname" {
  count   = var.redis-janus-bcookie["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "janus-bcookie--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.janus-bcookie[count.index].configuration_endpoint_address]
}

###############################
# oxygen
###############################

variable "redis-oxygen" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "oxygen" {
  count                         = var.redis-oxygen["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-oxygen,"snapshot_name","")
  snapshot_arns = lookup(var.redis-oxygen,"snapshot_arns",null) == null ? null : split(",", var.redis-oxygen["snapshot_arns"])
  replication_group_id          = "oxygen-${var.env}"
  replication_group_description = var.redis-oxygen["ticket"]
  node_type                     = var.redis-oxygen["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "jtier-oxygen"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-oxygen["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "oxygen_cname" {
  count   = var.redis-oxygen["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "oxygen--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.oxygen[count.index].primary_endpoint_address]
}

###############################
# relevance-sponsored-deals
###############################

variable "redis-relevance-sponsored-deals" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "relevance-sponsored-deals" {
  count                         = var.redis-relevance-sponsored-deals["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-relevance-sponsored-deals,"snapshot_name","")
  snapshot_arns = lookup(var.redis-relevance-sponsored-deals,"snapshot_arns",null) == null ? null : split(",", var.redis-relevance-sponsored-deals["snapshot_arns"])
  replication_group_id          = "relevance-sponsored-deals-${var.env}"
  replication_group_description = var.redis-relevance-sponsored-deals["ticket"]
  node_type                     = var.redis-relevance-sponsored-deals["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-relevance-sponsored-deals["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "relevance-sponsored-deals_cname" {
  count   = var.redis-relevance-sponsored-deals["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "relevance-sponsored-deals--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.relevance-sponsored-deals[count.index].primary_endpoint_address]
}

###############################
# unity-gifting-emailer
###############################

variable "redis-unity-gifting-emailer" {
  type = map
  default = { create = false }
}
variable "redis_unity_gifting_emailer_AUTH" {
  type = string
}

resource "aws_elasticache_replication_group" "unity-gifting-emailer" {
  count                         = var.redis-unity-gifting-emailer["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-unity-gifting-emailer,"snapshot_name","")
  snapshot_arns = lookup(var.redis-unity-gifting-emailer,"snapshot_arns",null) == null ? null : split(",", var.redis-unity-gifting-emailer["snapshot_arns"])
  replication_group_id          = "unity-gifting-emailer-${var.env}"
  replication_group_description = var.redis-unity-gifting-emailer["ticket"]
  node_type                     = var.redis-unity-gifting-emailer["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_unity_gifting_emailer_AUTH                    # bast

  tags = {
    TenantService   = "gifting-emailer"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-unity-gifting-emailer["ticket"]
    OOMAlertsOptOut = false
    BastLevel       = "C2"
  }
}

resource "aws_route53_record" "unity-gifting-emailer_cname" {
  count   = var.redis-unity-gifting-emailer["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "unity-gifting-emailer--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.unity-gifting-emailer[count.index].primary_endpoint_address]
}

###############################
# vex
###############################

variable "redis-vex" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "vex" {
  count                         = var.redis-vex["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-vex,"snapshot_name","")
  snapshot_arns = lookup(var.redis-vex,"snapshot_arns",null) == null ? null : split(",", var.redis-vex["snapshot_arns"])
  replication_group_id          = "vex-${var.env}"
  replication_group_description = var.redis-vex["ticket"]
  node_type                     = var.redis-vex["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "vex"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-vex["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "vex_cname" {
  count   = var.redis-vex["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "vex--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.vex[count.index].primary_endpoint_address]
}

###############################
# merchant-advisor
###############################

variable "redis-merchant-advisor" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "merchant-advisor" {
  count                         = var.redis-merchant-advisor["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-merchant-advisor,"snapshot_name","")
  snapshot_arns = lookup(var.redis-merchant-advisor,"snapshot_arns",null) == null ? null : split(",", var.redis-merchant-advisor["snapshot_arns"])
  replication_group_id          = "merchant-advisor-${var.env}"
  replication_group_description = var.redis-merchant-advisor["ticket"]
  node_type                     = var.redis-merchant-advisor["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "merchant-advisor-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-merchant-advisor["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "merchant-advisor_cname" {
  count   = var.redis-merchant-advisor["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "merchant-advisor--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.merchant-advisor[count.index].primary_endpoint_address]
}

###############################
# general-ledger-gateway
###############################

variable "redis-general-ledger-gateway" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "general-ledger-gateway" {
  count                         = var.redis-general-ledger-gateway["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-general-ledger-gateway,"snapshot_name","")
  snapshot_arns = lookup(var.redis-general-ledger-gateway,"snapshot_arns",null) == null ? null : split(",", var.redis-general-ledger-gateway["snapshot_arns"])
  replication_group_id          = "general-ledger-gateway-${var.env}"
  replication_group_description = var.redis-general-ledger-gateway["ticket"]
  node_type                     = var.redis-general-ledger-gateway["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "general-ledger-gateway"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-general-ledger-gateway["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "general-ledger-gateway_cname" {
  count   = var.redis-general-ledger-gateway["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "general-ledger-gateway--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.general-ledger-gateway[count.index].primary_endpoint_address]
}

###############################
# search-backend
###############################

variable "redis-search-backend" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "search-backend" {
  count                         = var.redis-search-backend["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-search-backend,"snapshot_name","")
  snapshot_arns = lookup(var.redis-search-backend,"snapshot_arns",null) == null ? null : split(",", var.redis-search-backend["snapshot_arns"])
  replication_group_id          = "search-backend-${var.env}"
  replication_group_description = var.redis-search-backend["ticket"]
  node_type                     = var.redis-search-backend["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "autocomplete"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-search-backend["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "search-backend_cname" {
  count   = var.redis-search-backend["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "search-backend--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.search-backend[count.index].primary_endpoint_address]
}

###############################
# menu-service-v2-cache
###############################

variable "redis-menu-service-v2-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "menu-service-v2-cache" {
  count                         = var.redis-menu-service-v2-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-menu-service-v2-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-menu-service-v2-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-menu-service-v2-cache["snapshot_arns"])
  replication_group_id          = "menu-service-v2-cache-${var.env}"
  replication_group_description = var.redis-menu-service-v2-cache["ticket"]
  node_type                     = var.redis-menu-service-v2-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "menu-service-v2"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-menu-service-v2-cache["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "menu-service-v2-cache_cname" {
  count   = var.redis-menu-service-v2-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "menu-service-v2-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.menu-service-v2-cache[count.index].primary_endpoint_address]
}

###############################
# quantum-lead
###############################

variable "redis-quantum-lead" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "quantum-lead" {
  count                         = var.redis-quantum-lead["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-quantum-lead,"snapshot_name","")
  snapshot_arns = lookup(var.redis-quantum-lead,"snapshot_arns",null) == null ? null : split(",", var.redis-quantum-lead["snapshot_arns"])
  replication_group_id          = "quantum-lead-${var.env}"
  replication_group_description = var.redis-quantum-lead["ticket"]
  node_type                     = var.redis-quantum-lead["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "salesforce-cache"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-quantum-lead["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "quantum-lead_cname" {
  count   = var.redis-quantum-lead["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "quantum-lead--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.quantum-lead[count.index].primary_endpoint_address]
}

###############################
# dispatcher-cache
###############################

variable "redis-dispatcher-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "dispatcher-cache" {
  count                         = var.redis-dispatcher-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-dispatcher-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-dispatcher-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-dispatcher-cache["snapshot_arns"])
  replication_group_id          = "dispatcher-cache-${var.env}"
  replication_group_description = var.redis-dispatcher-cache["ticket"]
  node_type                     = var.redis-dispatcher-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-dispatcher-cache["num_nodes"]
  }

  tags = {
    TenantService   = "rocketman-commercial"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-dispatcher-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "dispatcher-cache_cname" {
  count   = var.redis-dispatcher-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "dispatcher-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.dispatcher-cache[count.index].configuration_endpoint_address]
}

###############################
# m3-merchant-service-cache
###############################

variable "redis-m3-merchant-service-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "m3-merchant-service-cache" {
  count                         = var.redis-m3-merchant-service-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-m3-merchant-service-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-m3-merchant-service-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-m3-merchant-service-cache["snapshot_arns"])
  replication_group_id          = "m3-merchant-service-cache-${var.env}"
  replication_group_description = var.redis-m3-merchant-service-cache["ticket"]
  node_type                     = var.redis-m3-merchant-service-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "m3_merchant_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-m3-merchant-service-cache["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "m3-merchant-service-cache_cname" {
  count   = var.redis-m3-merchant-service-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "m3-merchant-service-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.m3-merchant-service-cache[count.index].primary_endpoint_address]
}

###############################
# cds-cache
###############################

variable "redis-cds-cache" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "cds-cache" {
  count                         = var.redis-cds-cache["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-cds-cache,"snapshot_name","")
  snapshot_arns = lookup(var.redis-cds-cache,"snapshot_arns",null) == null ? null : split(",", var.redis-cds-cache["snapshot_arns"])
  replication_group_id          = "cds-cache-${var.env}"
  replication_group_description = var.redis-cds-cache["ticket"]
  node_type                     = var.redis-cds-cache["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "coupons-data-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-cds-cache["ticket"]
    OOMAlertsOptOut = true
  }
}

resource "aws_route53_record" "cds-cache_cname" {
  count   = var.redis-cds-cache["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "cds-cache--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.cds-cache[count.index].primary_endpoint_address]
}

###############################
# jarvis-bot
###############################

variable "redis-jarvis-bot" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "jarvis-bot" {
  count                         = var.redis-jarvis-bot["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-jarvis-bot,"snapshot_name","")
  snapshot_arns = lookup(var.redis-jarvis-bot,"snapshot_arns",null) == null ? null : split(",", var.redis-jarvis-bot["snapshot_arns"])
  replication_group_id          = "jarvis-bot-${var.env}"
  replication_group_description = var.redis-jarvis-bot["ticket"]
  node_type                     = var.redis-jarvis-bot["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "jarvis-bot"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-jarvis-bot["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "jarvis-bot_cname" {
  count   = var.redis-jarvis-bot["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "jarvis-bot--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.jarvis-bot[count.index].primary_endpoint_address]
}

###############################
# prodcat
###############################

variable "redis-prodcat" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "prodcat" {
  count                         = var.redis-prodcat["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-prodcat,"snapshot_name","")
  snapshot_arns = lookup(var.redis-prodcat,"snapshot_arns",null) == null ? null : split(",", var.redis-prodcat["snapshot_arns"])
  replication_group_id          = "prodcat-${var.env}"
  replication_group_description = var.redis-prodcat["ticket"]
  node_type                     = var.redis-prodcat["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "prodcat"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-prodcat["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "prodcat_cname" {
  count   = var.redis-prodcat["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "prodcat--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.prodcat[count.index].primary_endpoint_address]
}

###############################
# edrans-test
###############################

variable "redis-edrans-test" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "edrans-test" {
  count                         = var.redis-edrans-test["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-edrans-test,"snapshot_name","")
  snapshot_arns = lookup(var.redis-edrans-test,"snapshot_arns",null) == null ? null : split(",", var.redis-edrans-test["snapshot_arns"])
  replication_group_id          = "edrans-test-${var.env}"
  replication_group_description = var.redis-edrans-test["ticket"]
  node_type                     = var.redis-edrans-test["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "raas"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-edrans-test["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "edrans-test_cname" {
  count   = var.redis-edrans-test["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "edrans-test--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.edrans-test[count.index].primary_endpoint_address]
}

###############################
# pricing
###############################

variable "redis-pricing" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "pricing" {
  count                         = var.redis-pricing["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-pricing,"snapshot_name","")
  snapshot_arns = lookup(var.redis-pricing,"snapshot_arns",null) == null ? null : split(",", var.redis-pricing["snapshot_arns"])
  replication_group_id          = "pricing-${var.env}"
  replication_group_description = var.redis-pricing["ticket"]
  node_type                     = var.redis-pricing["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-pricing["num_nodes"]
  }

  tags = {
    TenantService   = "pricing_service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-pricing["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "pricing_cname" {
  count   = var.redis-pricing["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "pricing--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.pricing[count.index].configuration_endpoint_address]
}

###############################
# arbitration
###############################

variable "redis-arbitration" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "arbitration" {
  count                         = var.redis-arbitration["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-arbitration,"snapshot_name","")
  snapshot_arns = lookup(var.redis-arbitration,"snapshot_arns",null) == null ? null : split(",", var.redis-arbitration["snapshot_arns"])
  replication_group_id          = "arbitration-${var.env}"
  replication_group_description = var.redis-arbitration["ticket"]
  node_type                     = var.redis-arbitration["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-arbitration["num_nodes"]
  }

  tags = {
    TenantService   = "arbitration-service"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-arbitration["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "arbitration_cname" {
  count   = var.redis-arbitration["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "arbitration--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.arbitration[count.index].configuration_endpoint_address]
}

###############################
# mx
###############################

variable "redis-mx" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mx" {
  count                         = var.redis-mx["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mx,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mx,"snapshot_arns",null) == null ? null : split(",", var.redis-mx["snapshot_arns"])
  replication_group_id          = "mx-${var.env}"
  replication_group_description = var.redis-mx["ticket"]
  node_type                     = var.redis-mx["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mx-merchant-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mx["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "mx_cname" {
  count   = var.redis-mx["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mx--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mx[count.index].primary_endpoint_address]
}

###############################
# mx-reporting
###############################

variable "redis-mx-reporting" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mx-reporting" {
  count                         = var.redis-mx-reporting["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mx-reporting,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mx-reporting,"snapshot_arns",null) == null ? null : split(",", var.redis-mx-reporting["snapshot_arns"])
  replication_group_id          = "mx-reporting-${var.env}"
  replication_group_description = var.redis-mx-reporting["ticket"]
  node_type                     = var.redis-mx-reporting["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mx-merchant-reporting"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mx-reporting["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "mx-reporting_cname" {
  count   = var.redis-mx-reporting["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mx-reporting--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mx-reporting[count.index].primary_endpoint_address]
}

###############################
# autocomplete
###############################

variable "redis-autocomplete" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "autocomplete" {
  count                         = var.redis-autocomplete["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-autocomplete,"snapshot_name","")
  snapshot_arns = lookup(var.redis-autocomplete,"snapshot_arns",null) == null ? null : split(",", var.redis-autocomplete["snapshot_arns"])
  replication_group_id          = "autocomplete-${var.env}"
  replication_group_description = var.redis-autocomplete["ticket"]
  node_type                     = var.redis-autocomplete["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-autocomplete["num_nodes"]
  }

  tags = {
    TenantService   = "autocomplete"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-autocomplete["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "autocomplete_cname" {
  count   = var.redis-autocomplete["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "autocomplete--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.autocomplete[count.index].configuration_endpoint_address]
}

###############################
# inbox-mgmt-email-stg-users01
###############################

variable "redis-inbox-mgmt-email-stg-users01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-email-stg-users01" {
  count                         = var.redis-inbox-mgmt-email-stg-users01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-email-stg-users01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-email-stg-users01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-email-stg-users01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-email-stg-users01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-email-stg-users01["ticket"]
  node_type                     = var.redis-inbox-mgmt-email-stg-users01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-email-stg-users01["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "inbox-mgmt-email-stg-users01_cname" {
  count   = var.redis-inbox-mgmt-email-stg-users01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-email-stg-users01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-email-stg-users01[count.index].primary_endpoint_address]
}

###############################
# inbox-mgmt-mobile-stg-users01
###############################

variable "redis-inbox-mgmt-mobile-stg-users01" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "inbox-mgmt-mobile-stg-users01" {
  count                         = var.redis-inbox-mgmt-mobile-stg-users01["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-inbox-mgmt-mobile-stg-users01,"snapshot_name","")
  snapshot_arns = lookup(var.redis-inbox-mgmt-mobile-stg-users01,"snapshot_arns",null) == null ? null : split(",", var.redis-inbox-mgmt-mobile-stg-users01["snapshot_arns"])
  replication_group_id          = "inbox-mgmt-mobile-stg-users01-${var.env}"
  replication_group_description = var.redis-inbox-mgmt-mobile-stg-users01["ticket"]
  node_type                     = var.redis-inbox-mgmt-mobile-stg-users01["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "inbox_management_platform"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-inbox-mgmt-mobile-stg-users01["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "inbox-mgmt-mobile-stg-users01_cname" {
  count   = var.redis-inbox-mgmt-mobile-stg-users01["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "inbox-mgmt-mobile-stg-users01--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.inbox-mgmt-mobile-stg-users01[count.index].primary_endpoint_address]
}

###############################
# mls-rin
###############################

variable "redis-mls-rin" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mls-rin" {
  count                         = var.redis-mls-rin["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mls-rin,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mls-rin,"snapshot_arns",null) == null ? null : split(",", var.redis-mls-rin["snapshot_arns"])
  replication_group_id          = "mls-rin-${var.env}"
  replication_group_description = var.redis-mls-rin["ticket"]
  node_type                     = var.redis-mls-rin["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "mls-rin"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mls-rin["ticket"]
    OOMAlertsOptOut = false
    Resque          = true
  }
}

resource "aws_route53_record" "mls-rin_cname" {
  count   = var.redis-mls-rin["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mls-rin--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mls-rin[count.index].primary_endpoint_address]
}

###############################
# geo-bhuvan-cache-new
###############################

variable "redis-geo-bhuvan-cache-new" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "geo-bhuvan-cache-new" {
  count                         = var.redis-geo-bhuvan-cache-new["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-geo-bhuvan-cache-new,"snapshot_name","")
  snapshot_arns = lookup(var.redis-geo-bhuvan-cache-new,"snapshot_arns",null) == null ? null : split(",", var.redis-geo-bhuvan-cache-new["snapshot_arns"])
  replication_group_id          = "geo-bhuvan-cache-new-${var.env}"
  replication_group_description = var.redis-geo-bhuvan-cache-new["ticket"]
  node_type                     = var.redis-geo-bhuvan-cache-new["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-geo-bhuvan-cache-new["num_nodes"]
  }

  tags = {
    TenantService   = "bhuvan"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-geo-bhuvan-cache-new["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "geo-bhuvan-cache-new_cname" {
  count   = var.redis-geo-bhuvan-cache-new["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "geo-bhuvan-cache-new--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.geo-bhuvan-cache-new[count.index].configuration_endpoint_address]
}

###############################
# watson-user-kv-test
###############################

variable "redis-watson-user-kv-test" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "watson-user-kv-test" {
  count                         = var.redis-watson-user-kv-test["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = true
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-watson-user-kv-test,"snapshot_name","")
  snapshot_arns = lookup(var.redis-watson-user-kv-test,"snapshot_arns",null) == null ? null : split(",", var.redis-watson-user-kv-test["snapshot_arns"])
  replication_group_id          = "watson-user-kv-test-${var.env}"
  replication_group_description = var.redis-watson-user-kv-test["ticket"]
  node_type                     = var.redis-watson-user-kv-test["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_in_other_region_sg[0].id, aws_security_group.raas_allow_dnd_account_sg[0].id, aws_security_group.raas_allow_emr_account_sg[0].id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  cluster_mode {
    replicas_per_node_group = 0
    num_node_groups         = var.redis-watson-user-kv-test["num_nodes"]
  }

  tags = {
    TenantService   = "watson-api"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-watson-user-kv-test["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "watson-user-kv-test_cname" {
  count   = var.redis-watson-user-kv-test["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "watson-user-kv-test--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.watson-user-kv-test[count.index].configuration_endpoint_address]
}

###############################
# rapi-citrus-ads
###############################

variable "redis-rapi-citrus-ads" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "rapi-citrus-ads" {
  count                         = var.redis-rapi-citrus-ads["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-rapi-citrus-ads,"snapshot_name","")
  snapshot_arns = lookup(var.redis-rapi-citrus-ads,"snapshot_arns",null) == null ? null : split(",", var.redis-rapi-citrus-ads["snapshot_arns"])
  replication_group_id          = "rapi-citrus-ads-${var.env}"
  replication_group_description = var.redis-rapi-citrus-ads["ticket"]
  node_type                     = var.redis-rapi-citrus-ads["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "relevance"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-rapi-citrus-ads["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "rapi-citrus-ads_cname" {
  count   = var.redis-rapi-citrus-ads["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "rapi-citrus-ads--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.rapi-citrus-ads[count.index].primary_endpoint_address]
}

###############################
# mobile-next
###############################

variable "redis-mobile-next" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "mobile-next" {
  count                         = var.redis-mobile-next["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-mobile-next,"snapshot_name","")
  snapshot_arns = lookup(var.redis-mobile-next,"snapshot_arns",null) == null ? null : split(",", var.redis-mobile-next["snapshot_arns"])
  replication_group_id          = "mobile-next-${var.env}"
  replication_group_description = var.redis-mobile-next["ticket"]
  node_type                     = var.redis-mobile-next["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "next-pwa-app"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-mobile-next["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "mobile-next_cname" {
  count   = var.redis-mobile-next["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "mobile-next--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.mobile-next[count.index].primary_endpoint_address]
}

###############################
# editorial-writers
###############################

variable "redis-editorial-writers" {
  type = map
  default = { create = false }
}

resource "aws_elasticache_replication_group" "editorial-writers" {
  count                         = var.redis-editorial-writers["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "6.x"
  apply_immediately             = true
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  maintenance_window = (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30")
  snapshot_window = (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00")
  snapshot_retention_limit = 14
  snapshot_name = lookup(var.redis-editorial-writers,"snapshot_name","")
  snapshot_arns = lookup(var.redis-editorial-writers,"snapshot_arns",null) == null ? null : split(",", var.redis-editorial-writers["snapshot_arns"])
  replication_group_id          = "editorial-writers-${var.env}"
  replication_group_description = var.redis-editorial-writers["ticket"]
  node_type                     = var.redis-editorial-writers["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [aws_security_group.raas_redis_conveyor.id, aws_security_group.raas_allow_conveyor_gcp_sg[0].id]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
  number_cache_clusters         = 1

  tags = {
    TenantService   = "gazebo"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-editorial-writers["ticket"]
    OOMAlertsOptOut = false
  }
}

resource "aws_route53_record" "editorial-writers_cname" {
  count   = var.redis-editorial-writers["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "editorial-writers--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_replication_group.editorial-writers[count.index].primary_endpoint_address]
}
