memcached-cluster-test1 = {
  create = false
  num_nodes = 2
  node_type = "cache.t3.micro"
  ticket = "RAAS-58"
}
memcached-cluster-test1-AZs = ["eu-west-1a", "eu-west-1b"]


memcached-test2 = {
  create = false
  num_nodes = 1
  node_type = "cache.t3.micro"
  ticket = "RAAS-58"
}
