redis-taxonomyv2 = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6665"
}

redis-tpis = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6769"
}

redis-cobot = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6790"
}

redis-rfake1 = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "DATA-7169"
}

redis-rfake2 = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "DATA-7194"
}

redis-rfs-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7209"
}

redis-test-bast = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "DATA-7212"
  auth_token = "superpasswordhelloworld!"
}

redis-mentos-cache = {
  create = false
  node_type = "cache.t3.micro"
  ticket = "DATA-7222"
}

redis-test2 = {
  create = false
  node_type = "cache.r6g.large"
  ticket = "RAAS-469"
  num_nodes = 2
}
