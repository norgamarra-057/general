redis-dealshow = {
  create = false
  node_type = "cache.r5.large"
  ticket = "DATA-7463"
  num_nodes = 2
}

redis-pagination = {
  create = false
  node_type = "cache.r5.large"
  ticket = "DATA-7464"
  num_nodes = 3
}

redis-oxygen = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-346"
}

redis-watson-search-kv = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-386"
}

redis-holmes-user-search-personalize = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-380"
  param_group = "global-datastore-holmes-user-search-personalize-prod-repiuud"
}

redis-holmes-user-recent-searches = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-382"
}

redis-content-service-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-157"
}

redis-dispatcher-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-767"
  num_nodes = 8
}

redis-relevance-sponsored-deals = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-375"
}

redis-ipam = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-708"
}

redis-jarvis-bot = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-722"
}

redis-rapi-citrus-ads = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1058"
}