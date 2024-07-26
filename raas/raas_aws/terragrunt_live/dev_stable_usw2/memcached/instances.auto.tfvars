memcached-mfake = {
  create = false
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "DATA-6499"
}
memcached-mfake-AZs = ["us-west-2a", "us-west-2b"]

memcached-deckard = {
  create = false
  num_nodes = 9
  node_type = "cache.t3.micro"
  ticket = "DATA-7243"
}
memcached-deckard-AZs = ["us-west-2a","us-west-2a","us-west-2a","us-west-2b","us-west-2b","us-west-2b","us-west-2c","us-west-2c","us-west-2c"]

memcached-cluster-test1 = {
  create = false
  num_nodes = 4
  node_type = "cache.t3.micro"
  ticket = "RAAS-19"
}
memcached-cluster-test1-AZs = ["us-west-2a", "us-west-2b","us-west-2a", "us-west-2b"]


memcached-test2 = {
  create = false
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-19"
}
