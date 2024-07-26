redis-test1 = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-641"
  snapshot_name = "test1-manual-20220531-01"
}

redis-test2 = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-641"
  num_nodes = 2
  snapshot_name = "manual-test2-dev-2022-05-31-08-01"
}
