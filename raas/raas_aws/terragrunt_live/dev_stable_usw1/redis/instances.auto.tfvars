redis-test1 = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "RAAS-365"
}
redis-test2 = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "RAAS-365"
  num_nodes = 2
}

redis-taxonomyv2 = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "DATA-6665"
}

redis-tpis = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6769"
}

redis-rfs-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7209"
}

redis-mentos-cache = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "DATA-7222"
}
