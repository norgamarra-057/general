redis-taxonomyv2 = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "DATA-6664"
}

redis-api-proxy = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6633"
}

redis-dlsvc-shield-cache = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "DATA-6773"
}

redis-dlsvc-shield-queue = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7275"
}

redis-vis = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "DATA-6765"
  num_nodes = 2
}

redis-tpis = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6768"
}

redis-rapi-rt-pag = {
  create = true
  num_nodes = 2
  node_type = "cache.t4g.micro"
  ticket = "DATA-6879"
}

redis-rfs-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7210"
}

redis-layout-svc-templates = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7395"
}

redis-dealshow = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7465"
  num_nodes = 1
  reserved-memory-percent = 40
}

redis-deckard-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7648"
  num_nodes = 2
}

redis-deckard-async = {
  create = true
  node_type = "cache.t3.micro"
  ticket = "DATA-7812"
}

redis-cs-api = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-11"
}

redis-batch-quraas = {
  create = false
  node_type = "cache.t4g.small"
  ticket = "RAAS-59"
}

redis-metro = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-77"
}

redis-bros-cache = {
  create = false
  node_type = "cache.t4g.small"
  ticket = "RAAS-139"
}

redis-fraud-arbiter-config = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-178"
}

redis-fraud-arbiter-cache = {
  create = false
  node_type = "cache.t4g.small"
  ticket = "RAAS-180"
}

redis-proximity-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-144"
}

redis-regla = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-145"
}

redis-targeted-deal-message-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-146"
}

redis-dynamo = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-159"
}

redis-orders = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-142"
}

redis-orders-conveyor = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-583"
}

redis-fraud = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-231"
}

redis-getaways-inventory = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-247"
}

redis-appointments-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-254"
}

redis-billing-record-service = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-256"
}

redis-custsvc = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-263"
}

redis-custsvc-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-264"
}

redis-killbill = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-290"
}

redis-rise = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-298"
}

redis-ticketsvc = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-302"
}

redis-users-service = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-304"
}

redis-ugc = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-303"
}

redis-cs-api-cache = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-317"
}

redis-oxygen = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-346"
}

redis-voucher-inventory = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-305"
}

redis-afl-pcs = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-252"
}

redis-badges = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-747"
  oom_thresholds = "94:95"
}

redis-content-service-cache = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-157"
}

redis-geo-bhuvan-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 1
}

redis-geo-bhuvan-indexer = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 2
}

redis-geo-bhuvan-geoms = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 1
}

redis-orders-cloud = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-440"
}

redis-calendar-service-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-194"
}

redis-incentive-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-286"
}

redis-rm-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-340"
  num_nodes = 2
}

redis-lazlo-deals = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-250"
}

redis-goods-inventory-service = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-553"
}

redis-ugc-cache = {
  create = true
  node_type = "cache.m6g.large"
  num_nodes = 1
  ticket = "RAAS-596"
}

redis-mppservice-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-293"
}

redis-m3-merchant-service-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-633"
}

redis-m3-placeread = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-709"
  num_nodes = 1
}

redis-getaways-search-cache = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-620"
}

redis-supply-chain-gateway-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-638"
}

redis-prodcat = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-648"
}

redis-jarvis-bot = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-647"
}

redis-getaways-inventory-product = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-654"
}

redis-test4 = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-699"
  num_nodes = 2
}

redis-control-cloud = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-56"
}

redis-wishlist = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 2
  ticket = "RAAS-228"
}

redis-coupon-worker = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-928"
}

redis-watson-search-kv = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-386"
}

redis-quantum-lead = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-610"
}

redis-edrans-test = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1"
}

redis-rapi-citrus-ads = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1058"
}

redis-ob-3rd-party-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1082"
}