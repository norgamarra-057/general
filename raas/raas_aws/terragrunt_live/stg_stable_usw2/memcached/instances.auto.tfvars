memcached-layout-svc = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6661"
}
memcached-layout-svc-AZs = ["us-west-2a","us-west-2b"]

memcached-occasions = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  subnet_group_name = "raas-memcached-b-staging"
  ticket = "DATA-6498"
  az_mode = "single-az"
}
memcached-occasions-AZs = ["us-west-2b","us-west-2b"]

memcached-usr-sessions = {
  create = true
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "DATA-6647"
}

memcached-unwrap = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6671"
}
memcached-unwrap-AZs = ["us-west-2a", "us-west-2b"]

memcached-cont-pages = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6678"
}
memcached-cont-pages-AZs = ["us-west-2a", "us-west-2c"]

memcached-coupons = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6744"
}
memcached-coupons-AZs = ["us-west-2a","us-west-2b"]

memcached-pull = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6762"
}
memcached-pull-AZs = ["us-west-2a","us-west-2b"]

memcached-deckard = {
  create = false
  num_nodes = 9
  node_type = "cache.t3.micro"
  ticket = "DATA-7254"
}
memcached-deckard-AZs = ["us-west-2a","us-west-2a","us-west-2a","us-west-2b","us-west-2b","us-west-2b","us-west-2c","us-west-2c","us-west-2c"]

memcached-sub-center = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7262"
}
memcached-sub-center-AZs = ["us-west-2a","us-west-2c"]

memcached-subscription-flow = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7397"
}
memcached-subscription-flow-AZs = ["us-west-2a","us-west-2c"]

memcached-getaways-browse = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7658"
}
memcached-getaways-browse-AZs = ["us-west-2a","us-west-2c"]


memcached-tpis-booking-ita = {
  create = true
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-7704"
}
memcached-tpis-booking-ita-AZs = ["us-west-2a","us-west-2c"]

memcached-booking-engine-appointments1 = {
  create = false
  num_nodes = 1
  node_type = "cache.t4g.small"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments1-AZs = ["us-west-2a","us-west-2b","us-west-2c"]

memcached-booking-engine-appointments2 = {
  create = false
  num_nodes = 1
  node_type = "cache.t4g.small"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments2-AZs = ["us-west-2a","us-west-2b","us-west-2c"]

memcached-booking-engine-appointments3 = {
  create = false
  num_nodes = 1
  node_type = "cache.t4g.small"
  ticket = "RAAS-373"
}
memcached-booking-engine-appointments3-AZs = ["us-west-2a","us-west-2b","us-west-2c"]

memcached-goods-outbound-controller = {
  create = true
  num_nodes = 2
  node_type = "cache.t4g.micro"
  ticket = "RAAS-281"
}
memcached-goods-outbound-controller-AZs = ["us-west-2a","us-west-2c"]
