memcached-layout-svc = {
  create = true
  num_nodes = 2
  node_type = "cache.m5.large"
  ticket = "DATA-6662"
}
memcached-layout-svc-AZs = ["eu-west-1a","eu-west-1a", "eu-west-1b","eu-west-1b", "eu-west-1c","eu-west-1c"]

memcached-checkout = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "DATA-6691"
}
memcached-checkout-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-occasions = {
  create = true
  num_nodes = 2
  node_type = "cache.m5.large"
  subnet_group_name = "raas-memcached-abc-prod"
  ticket = "DATA-6567"
  az_mode = "cross-az" # legacy
}
memcached-occasions-AZs = ["eu-west-1a","eu-west-1a", "eu-west-1b","eu-west-1b", "eu-west-1c","eu-west-1c"]

memcached-usr-sessions = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "DATA-6657"
}

memcached-unwrap = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "DATA-6672"
}
memcached-unwrap-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-cont-pages = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "DATA-6684"
}
memcached-cont-pages-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-coupons = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.small"
  ticket = "DATA-6750"
}
memcached-coupons-AZs = ["eu-west-1a","eu-west-1b","eu-west-1c"]

memcached-pull = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.small"
  ticket = "DATA-6772"
}
memcached-pull-AZs = ["eu-west-1a","eu-west-1b","eu-west-1c"]

memcached-sub-center = {
  create = true
  num_nodes = 6
  node_type = "cache.t3.micro"
  ticket = "DATA-7280"
}
memcached-sub-center-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c","eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-subscription-flow = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "DATA-7434"
}
memcached-subscription-flow-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-getaways-browse = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "DATA-7660"
}
memcached-getaways-browse-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]


memcached-tpis-booking-ita = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "DATA-7710"
}
memcached-tpis-booking-ita-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-goods-outbound-controller = {
  create = true
  num_nodes = 3
  node_type = "cache.t3.micro"
  ticket = "RAAS-281"
}
memcached-goods-outbound-controller-AZs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

memcached-orders-cache = {
  create = true
  num_nodes = 1
  node_type = "cache.r6g.large"
  ticket = "RAAS-593"
}

memcached-booking-engine-appointments1 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.small"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments2 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.small"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments3 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.small"
  ticket = "RAAS-373"
}

