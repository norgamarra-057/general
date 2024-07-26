memcached-layout-svc = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6686"
}
memcached-layout-svc-AZs = ["us-west-1a","us-west-1c"]

memcached-usr-sessions = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "DATA-6647"
}

memcached-orders-cache = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.micro"
  ticket = "RAAS-590"
}

memcached-unwrap = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6671"
}
memcached-unwrap-AZs = ["us-west-1a", "us-west-1c"]

memcached-pull = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6762"
}
memcached-pull-AZs = ["us-west-1a","us-west-1c"]

memcached-skeletor-nex = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6771"
}
memcached-skeletor-nex-AZs = ["us-west-1a","us-west-1c"]

memcached-occasions = {
  create = true
  cname_suffix = ".service"
  num_nodes = 2
  node_type = "cache.t3.micro"
  subnet_group_name = "raas-memcached-cross-az-staging"
  ticket = "DATA-6860"
  az_mode = "cross-az"
}
memcached-occasions-AZs = ["us-west-1a","us-west-1c"]

memcached-sub-center = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7262"
}
memcached-sub-center-AZs = ["us-west-1a","us-west-1c"]

memcached-itier-ls-voucher-archive = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7285"
}
memcached-itier-ls-voucher-archive-AZs = ["us-west-1a","us-west-1c"]

memcached-subscription-flow = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7397"
}
memcached-subscription-flow-AZs = ["us-west-1a","us-west-1c"]

memcached-getaways-browse = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "DATA-7658"
}
memcached-getaways-browse-AZs = ["us-west-1a","us-west-1c"]


memcached-tpis-booking-ita = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7704"
}
memcached-tpis-booking-ita-AZs = ["us-west-1a","us-west-1c"]

memcached-editorial-writers-cache = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-275"
}
memcached-editorial-writers-cache-AZs = ["us-west-1a","us-west-1c"]

memcached-goods-outbound-controller = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "RAAS-281"
}
memcached-goods-outbound-controller-AZs = ["us-west-1a","us-west-1c"]

memcached-booking-engine-appointments1 = {
  create = false
  num_nodes = 1
  node_type = "cache.t4g.medium"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments1-AZs = ["us-west-1a","us-west-1c"]

memcached-booking-engine-appointments2 = {
  create = false
  num_nodes = 1
  node_type = "cache.t4g.medium"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments2-AZs = ["us-west-1a","us-west-1c"]

memcached-getaways-extranet = {
  create = true
  num_nodes = 2
  node_type = "cache.t4g.micro"
  ticket = "DATA-9070"
}
memcached-getaways-extranet-AZs = ["us-west-1a","us-west-1c"]

memcached-dealestate-cache = {
  create = true
  num_nodes = 1
  node_type = "cache.m6g.large"
  ticket = "RAAS-696"
}

memcached-deal = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "RAAS-12127"
}

memcached-coupons = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "DATA-6744"
}
memcached-coupons-AZs = ["us-west-1a","us-west-1c"]