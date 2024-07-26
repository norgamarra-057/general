redis-test3 = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-732"
}

redis-test4 = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-732"
  num_nodes = 2
}

redis-vis = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "DATA-6766"
  num_nodes = 3
}

redis-api-proxy = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-6942"
}

redis-dlsvc-shield-queue = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "DATA-7275"
}

redis-rfs-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7211"
}

redis-layout-svc-templates = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "DATA-7345"
}

redis-deckard-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "DATA-7780"
  num_nodes = 3
}

redis-deckard-async = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7782"
}

redis-cs-api = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-12"
}

redis-metro = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-102"
}

redis-pt-service-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-119"
}

redis-deal-book-service = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-125"
}

redis-accounting-service = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-153"
}

redis-bros-cache = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-192"
}

redis-backbeat = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-156"
}

redis-jarvis = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-217"
}

redis-dynamo = {
  create = true
  node_type = "cache.m6g.large"
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
  node_type = "cache.m6g.large"
  ticket = "RAAS-220"
}

redis-dealshow = {
  create = true
  node_type = "cache.r6g.xlarge"
  ticket = "RAAS-226"
  num_nodes = 15
}

redis-glive-gia = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-165"
}

redis-glive-inventory = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-166"
}

redis-ttd-gia-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-168"
}

redis-ttd-gis-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-169"
}

redis-orders = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-142"
}

redis-orders-dashboard = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-230"
}

redis-fraud = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-231"
}

redis-badges = {
  create = true
  node_type = "cache.m6g.large"
  num_nodes = 2
  ticket = "RAAS-747"
}

redis-calendar-service-cache = {
  create = true
  node_type = "cache.t4g.medium"
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

redis-goods-market-pricing = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-199"
}

redis-goodscentral = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-147"
}

redis-lbms-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-149"
}

redis-minos-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-200"
}

redis-offer-aggregator = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-202"
  param_group = "global-datastore-offer-aggregator-prodxnmc"
}

redis-tpis = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-174"
}

redis-supply-chain-gateway-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-203"
}

redis-custsvc-tokenizer = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-162"
}

redis-sportal-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-240"
}

# This db is deprecated!
#redis-sportal-sidekiq = {
#  create = false
#  node_type = "cache.t3.micro"
#  ticket = "RAAS-241"
#}

redis-sportal-workers-sidekiq = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-242"
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

redis-mobilebot-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-201"
}

redis-goods-stores = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-282"
}

redis-dmapi = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7372"
}

redis-m3-placeread = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-739"
  num_nodes = 2
}

redis-geo-bhuvan-geoms = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-306"
  num_nodes = 2
}

redis-geo-bhuvan-indexer = {
  create = true
  node_type = "cache.t4g.small"
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

redis-clo-service = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-260"
  oom_thresholds = "80:90"
}

redis-clo-service-jtier = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-261"
}

redis-coupon-worker = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-311"
}

redis-custsvc = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-263"
}

redis-custsvc-cache = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-264"
}

redis-dealestate-configuration = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-270"
}

redis-dealestate-resque = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-271"
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
  node_type = "cache.t4g.micro"
  ticket = "RAAS-286"
}

redis-crm-message-service = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-319"
}

redis-ingestion-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-287"
}

redis-ipam1 = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-288"
}

redis-mds = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-291"
}

redis-mppservice-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-293"
}

redis-rise = {
  create = true
  node_type = "cache.m6g.large"
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

redis-voucher-inventory = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-305"
}

redis-ugc = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-303"
}

redis-coupons-inventory = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-321"
}

redis-taxonomyv2 = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-301"
}

redis-holmes-lovo-rvd = {
  create = true
  node_type = "cache.r6g.2xlarge"
  ticket = "RAAS-322"
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
  node_type = "cache.r6g.xlarge"
  ticket = "RAAS-381"
  oom_thresholds = "80:90"
}

redis-holmes-user-rt-marketing = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-371"
}

redis-holmes-deals-rt-dsp = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-383"
}

redis-watson-freshness = {
  create = true
  node_type = "cache.r6g.2xlarge"
  num_nodes = 7
  ticket = "RAAS-325"
  autoscaling_min_nodes = 6
  autoscaling_max_nodes = 7
  autoscaling_mem_target = 80
  oom_thresholds = "85:93"
  no_replica = true           #this field is for the github page and cost estimation only
}

redis-watson-user-kv = {
  create = true
  node_type = "cache.r6g.2xlarge"
  num_nodes = 4
  ticket = "RAAS-326"
  no_replica = true           #this field is for the github page and cost estimation only
}

redis-watson-deal-kv = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "RAAS-327"
  no_replica = true          #this field is for the github page and cost estimation only
}

redis-relevance-sponsored-deals = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-375"
}

redis-janus00 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus01 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus02 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus03 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus04 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus05 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus06 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus07 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus08 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus09 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus10 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus11 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus12 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus13 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus14 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}
redis-janus15 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-289"
}

redis-oxygen = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-346"
}

redis-rapi-pagination = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-389"
  num_nodes = 4
  no_replica = true           #this field is for the github page and cost estimation only
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

redis-transporter = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-188"
}

redis-vex = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-400"
}

redis-merchant-advisor = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-756"
}

redis-watson-search-kv = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-468"
}

redis-goods-inventory-service = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "RAAS-567"
}

redis-orders-conveyor = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-592"
}

redis-ugc2 = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-303"
}


redis-ugc-cache = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "RAAS-596"
  no_replica = true
}

redis-m3-merchant-service-cache = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-639"
}

redis-getaways-inventory-product = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-655"
}

redis-test3a = {
  create = false
  node_type = "cache.r6g.large"
  ticket = "RAAS-684"
  snapshot_name = "inbox-mgmt-mobile-prod-payload01-manual"
}


redis-test3b = {
  create = false
  node_type = "cache.r6g.large"
  ticket = "RAAS-684"
  snapshot_name = "inbox-mgmt-mobile-prod-events01-manual"
}


redis-test1a = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-684"
  #snapshot_name = "test-im-lock01-for-datatier-manual"
}


redis-test1b = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-684"
  #snapshot_name = "test-im-lock01-for-datatier-manual"
}

redis-test1c = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-684"
  #snapshot_name = "test-im-lock01-for-datatier-manual"
}

redis-pricing = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "RAAS-812"
  num_nodes = 2          
  no_replica = true #this field is for the github page and cost estimation only
}

redis-arbitration = {
  create = true
  node_type = "cache.m6g.large"
  num_nodes = 7
  ticket = "RAAS-828"
  no_replica = true
}

redis-dlsvc-shield-cache = {
  create = true
  node_type = "cache.r6g.xlarge"
  num_nodes = 7
  ticket = "RAAS-809"
  oom_thresholds = "87:93"
  no_replica = true           #this field is for the github page and cost estimation only
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
  node_type = "cache.m6g.large"
  num_nodes = 1
  ticket = "RAAS-50"
}

redis-mls-rin = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-873"
}

redis-geo-bhuvan-cache-new = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "RAAS-921"
}

redis-prodcat = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-984"
}

redis-quantum-lead = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-610"
}

redis-rapi-citrus-ads = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1058"
}

redis-mobile-next = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-1077"
}

redis-editorial-writers = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-2637"
}