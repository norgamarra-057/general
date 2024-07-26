memcached-layout-svc = {
  create = true
  num_nodes = 2
  node_type = "cache.m5.large"
  ticket = "DATA-6685"
}
memcached-layout-svc-AZs = ["us-west-1a","us-west-1a", "us-west-1c","us-west-1c"]

memcached-usr-sessions = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "DATA-6757"
}

memcached-pull = {
  create = true
  num_nodes = 4
  node_type = "cache.t3.small"
  ticket = "DATA-6789"
}
memcached-pull-AZs = ["us-west-1a","us-west-1a","us-west-1c", "us-west-1c"]

memcached-checkout = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6808"
}
memcached-checkout-AZs = ["us-west-1a", "us-west-1c"]

memcached-occasions = {
  create = true
  num_nodes = 6
  node_type = "cache.t3.medium"
  subnet_group_name = "raas-memcached-cross-az-prod"
  ticket = "DATA-6861"
  az_mode = "cross-az" # legacy
}
memcached-occasions-AZs = ["us-west-1a","us-west-1a","us-west-1a", "us-west-1c","us-west-1c","us-west-1c"]

memcached-sub-center = {
  create = true
  num_nodes = 4
  node_type = "cache.t3.micro"
  ticket = "DATA-7281"
}
memcached-sub-center-AZs = ["us-west-1a","us-west-1a", "us-west-1c","us-west-1c"]

memcached-itier-ls-voucher-archive = {
  create = true
  num_nodes = 4
  node_type = "cache.t3.micro"
  ticket = "DATA-7312"
}
memcached-itier-ls-voucher-archive-AZs = ["us-west-1a","us-west-1a", "us-west-1c","us-west-1c"]

memcached-coupons = {
  create = true
  num_nodes = 4
  node_type = "cache.t3.small"
  ticket = "DATA-6750"
}
memcached-coupons-AZs = ["us-west-1a","us-west-1a","us-west-1c","us-west-1c"]

memcached-clo-itier = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7403"
}
memcached-clo-itier-AZs = ["us-west-1a","us-west-1c"]

memcached-subscription-flow = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7435"
}
memcached-subscription-flow-AZs = ["us-west-1a","us-west-1c"]


memcached-getaways-browse = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7659"
}
memcached-getaways-browse-AZs = ["us-west-1a","us-west-1c"]


memcached-tpis-booking-ita = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7711"
}
memcached-tpis-booking-ita-AZs = ["us-west-1a","us-west-1c"]

memcached-awx-a-infosec-agent1 = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-94"
}

memcached-awx-a-infosec-agent2 = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-95"
}

memcached-awx-a-metrics-agent1 = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-96"
}

memcached-awx-a-metrics-agent2 = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-98"
}

memcached-cont-pages = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6684"
}
memcached-cont-pages-AZs = ["us-west-1a","us-west-1c"]

memcached-editorial-writers-cache = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "RAAS-275"
}
memcached-editorial-writers-cache-AZs = ["us-west-1a","us-west-1c"]

memcached-goods-outbound-controller = {
  create = true
  num_nodes = 4
  node_type = "cache.t3.micro"
  ticket = "RAAS-281"
}
memcached-goods-outbound-controller-AZs = ["us-west-1a","us-west-1a","us-west-1c","us-west-1c"]

memcached-goodscentral-cache = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "RAAS-283"
}
memcached-goodscentral-cache-AZs = ["us-west-1a","us-west-1c"]

memcached-getaways-extranet = {
  create = true
  num_nodes = 4
  node_type = "cache.t4g.micro"
  ticket = "DATA-9084"
}
memcached-getaways-extranet-AZs = ["us-west-1a","us-west-1a","us-west-1c","us-west-1c"]


memcached-accounting-service-memcache01 = {
  create = true
  num_nodes = 1
  node_type = "cache.m5.large"
  ticket = "RAAS-577"
}

memcached-accounting-service-memcache02 = {
  create = true
  num_nodes = 1
  node_type = "cache.m5.large"
  ticket = "RAAS-577"
}

memcached-accounting-service-memcache03 = {
  create = true
  num_nodes = 1
  node_type = "cache.m5.large"
  ticket = "RAAS-577"
}

memcached-orders-cache = {
  create = true
  num_nodes = 1
  node_type = "cache.r6g.large"
  ticket = "RAAS-593"
}

memcached-booking-engine-appointments1 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.medium"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments2 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.medium"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments3 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.medium"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments4 = {
  create = true
  num_nodes = 1
  node_type = "cache.t4g.medium"
  ticket = "RAAS-373"
}

memcached-dealestate-cache = {
  create = true
  num_nodes = 1
  node_type = "cache.m6g.large"
  ticket = "RAAS-696"
}

memcached-deal = {
  create = true
  num_nodes = 2
  node_type = "cache.m6g.large"
  ticket = "RAAS-12127"
}
