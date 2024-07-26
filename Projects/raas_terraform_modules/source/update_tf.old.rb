#!/usr/bin/env ruby

require 'yaml'
require 'erb'

def memcached_entry(name, h)
  allow_onprem = h['allow_onprem'] ? ', aws_security_group.raas_memcached_allow_onprem.id' : ''
  template = %q{
##########################
# <%= name %>
##########################
variable "memcached-<%= name %>" {
  type = map

  default = {
    create = false
  }
}
% unless h['single']

variable "memcached-<%= name %>-AZs" {
  type    = list
  default = []
}
%end

resource "aws_elasticache_cluster" "<%= name %>" {
  count                        = var.memcached-<%= name %>["create"] ? 1 : 0
  cluster_id                   = "<%= name %>-${var.env}"
  engine                       = local.engine
  engine_version               = "<%= h['version'] %>"
  apply_immediately            = true
  node_type                    = var.memcached-<%= name %>["node_type"]
  num_cache_nodes              = var.memcached-<%= name %>["num_nodes"]
% if h['legacy']
  subnet_group_name            = var.memcached-<%= name %>["subnet_group_name"]    # legacy, prefer "raas-memcached-cross-az
% else
  subnet_group_name            = "raas-memcached-cross-az-${var.env}"
% end
  security_group_ids           = [aws_security_group.raas_memcached_conveyor.id<%= allow_onprem %>]
  notification_topic_arn       = aws_sns_topic.elasticache_events.arn
% unless h['single']
%   if h['legacy']
  az_mode                      = var.memcached-<%= name %>["az_mode"]              # legacy, should always be "cross-az"
%   else
  az_mode                      = "cross-az"
%   end
  preferred_availability_zones = var.memcached-<%= name %>-AZs
% end
  parameter_group_name         = "default.memcached<%= h['version'].split('.')[0..1].join('.') %>"
  port                         = 11211

  tags = {
    TenantService   = "<%= h['service'] %>"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.memcached-<%= name %>["ticket"]
  }
}

% if h['legacy']
resource "aws_route53_record" "<%= name %>_cname" {
  count   = var.memcached-<%= name %>["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "<%= h['dnsalias'] || name %>--cache.${var.env}"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.<%= name %>[count.index].cluster_address]
}
# first cname was created before the ".service" suffix standard
# cname2 allows new memcached instances to be compliant:
resource "aws_route53_record" "<%= name %>_cname2" {
  count   = var.memcached-<%= name %>["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "<%= name %>--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.<%= name %>[count.index].cluster_address]
}
% else
resource "aws_route53_record" "<%= name %>_cname" {
  count   = var.memcached-<%= name %>["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "<%= h['dnsalias'] || name %>--cache.${var.env}.service"
  type    = "CNAME"
  ttl     = 1
  records = [aws_elasticache_cluster.<%= name %>[count.index].cluster_address]
}
% end
}
  ERB.new(template, 0, "%<>").result(binding)
end

def redis_entry(name, h)

  allow = ['aws_security_group.raas_redis_conveyor.id'] # conveyor by default
  if h['allow']
    allow << 'aws_security_group.raas_redis_allow_onprem.id' if h['allow'].include?('onprem') # onprem doesn't follow the sg naming standard we use for the rest
    h['allow'].each do |a|
      next if a == 'onprem'
      allow << "aws_security_group.raas_allow_#{a}_sg[0].id"
    end
  end
  security_group_ids = allow.join(', ')

  template = %q{
###############################
# <%= name %>
###############################

variable "redis-<%= name %>" {
  type = map
  default = { create = false }
}
% if h['bast']
variable "redis_<%= name.gsub('-','_') %>_AUTH" {
  type = string
}
% end

resource "aws_elasticache_replication_group" "<%= name %>" {
  count                         = var.redis-<%= name %>["create"] ? 1 : 0
  engine                        = local.engine
  engine_version                = "<%= h['version'] %>"
  apply_immediately             = true
% if h['cluster']
  automatic_failover_enabled    = true
% else
%   if h['staging_ha']
  automatic_failover_enabled    = true
%   else
  automatic_failover_enabled    = var.env == "prod" ? true : false
%   end
% end
% if h['staging_ha']
  multi_az_enabled              = true
% else
  multi_az_enabled              = var.env == "prod" ? true : false
% end
% if !h['staging_ha']
  maintenance_window = var.env != "prod" ? (substr(var.aws_region,0,2) == "us" ? "tue:09:30-tue:10:30" : "tue:02:30-tue:03:30") : ""
  snapshot_window = var.env != "prod" ? (substr(var.aws_region,0,2) == "us" ? "08:00-09:00" : "01:00-02:00") : ""
  snapshot_retention_limit = var.env != "prod" ? 14 : "0"
% end
  snapshot_name = lookup(var.redis-<%= name %>,"snapshot_name","")
  snapshot_arns = lookup(var.redis-<%= name %>,"snapshot_arns",null) == null ? null : split(",", var.redis-<%= name %>["snapshot_arns"])
  replication_group_id          = "<%= name %>-${var.env}"
  replication_group_description = var.redis-<%= name %>["ticket"]
% if h['global_datastore'] or h['param_group'] or h['instance_param_group']
%   if h['instance_param_group']
  parameter_group_name          = aws_elasticache_parameter_group.raas-redis<%= h['version'][0] %>-<%= name %>[count.index].id
%   elsif h['param_group']
  parameter_group_name          = aws_elasticache_parameter_group.<%= h['param_group'] %>.id
%   else
%     if h['global_datastore']
  parameter_group_name          = var.redis-<%= name %>["param_group"]
%     end
%   end
% end
  node_type                     = var.redis-<%= name %>["node_type"]
  subnet_group_name             = "raas-redis-cross-az-${var.env}"
  security_group_ids            = [<%= security_group_ids %>]
  notification_topic_arn        = aws_sns_topic.elasticache_events.arn
% if h['data_tiering']
  data_tiering_enabled          = true
% end
% if !h['cluster']
%   if h['staging_ha']
  number_cache_clusters         = 2                                                # master + replica
%   else
  number_cache_clusters         = var.env == "prod" ? 2 : 1
%   end
% end
% if h['bast']

  transit_encryption_enabled    = true                                             # bast
  at_rest_encryption_enabled    = true                                             # bast
  auth_token                    = var.redis_<%= name.gsub('-','_') %>_AUTH                    # bast
% end
% if h['cluster']
  cluster_mode {
%   if h['staging_ha']
    replicas_per_node_group = 1
%   else
    replicas_per_node_group = var.env == "prod" ? 1 : 0
%   end
    num_node_groups         = var.redis-<%= name %>["num_nodes"]
  }
% end

  tags = {
    TenantService   = "<%= h['service'] %>"
    Owner           = "raas-team@groupon.com"
    Service         = var.bbprovider
    Ticket          = var.redis-<%= name %>["ticket"]
    OOMAlertsOptOut = <%= h['oomalert'] ? 'false' : 'true' %>
% if h['resque']
    Resque          = true
% end
% if h['resque_ns']
    ResqueNamespace = "<%= h['resque_ns'] %>"
% end
% if h['bast']
    BastLevel       = "<%= h['bast'] %>"
% end
  }
}

resource "aws_route53_record" "<%= name %>_cname" {
  count   = var.redis-<%= name %>["create"] ? 1 : 0
  zone_id = data.aws_route53_zone.stable.id
  name    = "<%= h['dnsalias'] || name %>--${local.engine}.${var.env}"
  type    = "CNAME"
  ttl     = 1
% if h['cluster']
  records = [aws_elasticache_replication_group.<%= name %>[count.index].configuration_endpoint_address]
% else
  records = [aws_elasticache_replication_group.<%= name %>[count.index].primary_endpoint_address]
% end
}
% if h['autoscaling']

resource "aws_appautoscaling_target" "<%= name %>-autoscaling-nodes-target" {
  count   = var.redis-<%= name %>["create"] ? 1 : 0
  min_capacity       = var.redis-<%= name %>["autoscaling_min_nodes"]
  max_capacity       = var.redis-<%= name %>["autoscaling_max_nodes"]
  resource_id        = "replication-group/${aws_elasticache_replication_group.<%= name %>[count.index].id}"
  scalable_dimension = "elasticache:replication-group:NodeGroups"
  service_namespace  = "elasticache"
}

resource "aws_appautoscaling_policy" "<%= name %>-autoscaling-policy" {
  count   = var.redis-<%= name %>["create"] ? 1 : 0
  name               = "<%= name %>-autoscaling-mem-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.<%= name %>-autoscaling-nodes-target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.<%= name %>-autoscaling-nodes-target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.<%= name %>-autoscaling-nodes-target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ElastiCacheDatabaseMemoryUsageCountedForEvictPercentage"
    }
    target_value = var.redis-<%= name %>["autoscaling_mem_target"]
  }
}
% end
% if h['instance_param_group']

resource "aws_elasticache_parameter_group" "raas-redis<%= h['version'][0] %>-<%= name %>" {
  count   = var.redis-<%= name %>["create"] ? 1 : 0
  name   = "raas-redis<%= h['version'][0] %>-<%= name %>"
  family = "redis<%= h['version'][0] == '5' ? '5.0' : h['version'][0]+'.x' %>"

% if h['cluster']
  parameter {
    name  = "cluster-enabled"
    value = "yes"
  }
% end
<%   h['instance_param_group'].each do |p| %>
  parameter {
    name  = "<%= p %>"
    value = var.redis-<%= name %>["<%= p %>"]
  }
<%   end %>
}
% end
}
  ERB.new(template, 0, "%<>").result(binding)
end

File.open(File.join(__dir__, '..', 'redis/instances.tf'),'w') do |f|
  instances = YAML.load_file(File.join(__dir__,'redis_instances.yml'))
  instances.each do |k,v|
    f.write(redis_entry(k, v))
  end
end

File.open(File.join(__dir__, '..', 'memcached/instances.tf'),'w') do |f|
  instances = YAML.load_file(File.join(__dir__,'memcached_instances.yml'))
  instances.each do |k,v|
    f.write(memcached_entry(k, v))
  end
end
