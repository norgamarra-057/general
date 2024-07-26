redis-test1 = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "DATA-7017"
  version = "6.0.5"
}

redis-test2 = {
  create = false
  node_type = "cache.r6g.large"
  ticket = "RAAS-443"
  num_nodes = 2
}
