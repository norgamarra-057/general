redis-dealshow = {
  create = false
  node_type = "cache.t3.small"
  ticket = "DATA-7465"
  num_nodes = 2
  reserved-memory-percent = 25
}

redis-test2 = {
  create = false
  node_type = "cache.r6g.large"
  ticket = "RAAS-443"
  num_nodes = 2
}
