redis-vis = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "DATA-6766"
  num_nodes = 2
}

redis-dlsvc-shield-queue = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "DATA-7275"
}

redis-api-proxy = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6942"
}

redis-rfs-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7211"
}

redis-dealshow = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "DATA-7242"
  num_nodes = 2
  reserved-memory-percent = 25
}

redis-pagination = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "DATA-7241"
  num_nodes = 1
  no_replica = true           #this field is for the github page and cost estimation only
}

redis-layout-svc-templates = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "DATA-7301"
  no_replica = true
}

redis-deckard-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "DATA-7781"
  num_nodes = 2
  no_replica = true
}

redis-deckard-async = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7782"
}

redis-cs-api = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-12"
}

redis-metro = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-102"
}

redis-bros-cache = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-192"
}

redis-dynamo = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-159"
}

redis-proximity-cache = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-175"
}

redis-regla = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-176"
}

redis-targeted-deal-message-cache = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-220"
}

redis-orders = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-142"
}

redis-orders-dashboard = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-230"
}

redis-fraud = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-231"
}

redis-custsvc-tokenizer = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-162"
}

redis-getaways-inventory = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-247"
}
redis-getaways-search-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-246"
}

redis-badges = {
  create = true
  node_type = "cache.t4g.small"
  num_nodes = 1
  ticket = "RAAS-747"
}

redis-calendar-service-cache = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-194"
}

redis-casesservice-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-152"
}

redis-epods = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-193"
  no_replica = true
}

redis-lbms-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-149"
}

redis-tpis = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-174"
}

redis-supply-chain-gateway-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-203"
}

redis-geo-bhuvan-geoms = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 2
}
redis-geo-bhuvan-indexer = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-751"
  num_nodes = 1
}

redis-ob-3rd-party-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-251"
}

redis-appointments-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-254"
}

redis-billing-record-service = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-256"
}

redis-custsvc = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-263"
}

redis-custsvc-cache = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-264"
}

redis-custsvc-cache-irb = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-268"
}

redis-eds = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-276"
}

redis-bookingtool-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-277"
}

redis-incentive-cache = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-286"
}

redis-crm-message-service = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-319"
}

redis-killbill = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-290"
}

redis-mppservice-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-293"
}

redis-rise = {
  create = true
  node_type = "cache.t4g.small"
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
  node_type = "cache.t4g.medium"
  ticket = "RAAS-303"
}

redis-fraud-arbiter-queue = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-182"
}

redis-taxonomyv2 = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-301"
}

redis-holmes-user-identities = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-328"
}

redis-holmes-user-rt-search-eng = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-368"
}
redis-holmes-deal-rt-loci = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-369"
}
redis-holmes-deal-rt-goods = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-370"
}
redis-holmes-deals-rt-core-ranking = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-381"
  no_replica = true           #this field is for the github page and cost estimation only
}
redis-holmes-user-rt-marketing = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-371"
}
redis-holmes-user-search-personalize = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-380"
}

redis-holmes-deals-rt-dsp = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-383"
}

redis-watson-freshness = {
  create = true
  node_type = "cache.r6g.2xlarge"
  num_nodes = 3
  ticket = "RAAS-325"
  autoscaling_min_nodes = 3
  autoscaling_max_nodes = 4
  autoscaling_mem_target = 80
  oom_thresholds = "80:90"
  no_replica = true           #this field is for the github page and cost estimation only
}

redis-watson-user-kv = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 12
  ticket = "RAAS-326"
  no_replica = true           #this field is for the github page and cost estimation only
}

redis-watson-search-kv = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-386"
}

redis-watson-deal-kv = {
  create = true
  node_type = "cache.t4g.small"
  num_nodes = 4
  ticket = "RAAS-327"
}

redis-oxygen = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-346"
}

redis-voucher-inventory = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-305"
}

redis-rapi-hotel-show = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-390"
  num_nodes = 1
}
redis-rapi-merchandising-show = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-391"
  num_nodes = 1
}

redis-lbms-queue = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-399"
}

redis-lazlo-deals = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-442"
}

redis-goods-inventory-service = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "RAAS-574"
}

redis-orders-conveyor = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-592"
}

redis-ugc-cache = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 1
  ticket = "RAAS-596"
}

redis-dispatcher-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-746"
  num_nodes = 4
}

redis-m3-merchant-service-cache = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-639"
}

redis-m3-placeread = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-710"
  num_nodes = 1
}

redis-getaways-inventory-product = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-655"
}

redis-arbitration = {
  create = true
  node_type = "cache.m6g.large"
  num_nodes = 4
  ticket = "RAAS-828"
  no_replica = true
}

redis-dlsvc-shield-cache = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 4
  ticket = "RAAS-809"
  oom_thresholds = "87:93"
  no_replica = true           #this field is for the github page and cost estimation only
}

redis-control-cloud = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-57"
}

redis-mx-reporting = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-846"
}

redis-autocomplete = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-864"
}

redis-wishlist = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 2
  ticket = "RAAS-50"
}

redis-mls-rin = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-873"
}

redis-holmes-lovo-rvd = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-322"
}

redis-geo-bhuvan-cache-new = {
  create = true
  node_type = "cache.m6g.large"
  num_nodes = 2
  ticket = "RAAS-921"
}

redis-coupon-worker = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-929"
}

redis-quantum-lead = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-610"
}
