memcached-cluster-test1 = {
  create = false
  num_nodes = 2
  node_type = "cache.t3.micro"
  service = "raas"
  ticket = "RAAS-58"
}
memcached-cluster-test1-AZs = ["us-west-2a","us-west-2b"]
