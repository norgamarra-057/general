redis-merchant-advisor = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-435"
}

redis-taxonomyv2 = {
  create = true
  node_type = "cache.m6g.large"
  ticket = "DATA-6664"
}

redis-tpis = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "DATA-6768"
}

redis-rfs-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7210"
}

redis-layout-svc-templates = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7286"
}

redis-dmapi = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7398"
}

redis-cs-api = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-11"
}

redis-raas-im-node1 = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "DATA-7798"
}

redis-pizza-ng = {
  create = false
  node_type = "cache.t4g.micro"
  ticket = "RAAS-71"
}

redis-jarvis = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-76"
}

redis-metro = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-77"
}

redis-deal-book-service = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-88"
}

redis-pt-service-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-118"
}

redis-bros-cache = {
  create = false
  node_type = "cache.t4g.small"
  ticket = "RAAS-139"
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

#redis-goodscentral = {
#  create = true
#  node_type = "cache.t4g.micro"
#  ticket = "RAAS-147"
#}

redis-goodscentral-async = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-559"
}

redis-lbms-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-149"
}

redis-dynamo = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-159"
}

redis-custsvc-tokenizer = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-162"
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
  node_type = "cache.t4g.small"
  ticket = "RAAS-169"
}

redis-fraud-arbiter-config = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-178"
}

redis-fraud-arbiter-queue = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-179"
}

redis-fraud-arbiter-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-180"
}

redis-epods = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-193"
}

redis-transporter = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-187"
}

redis-goods-market-pricing = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-199"
}
redis-minos-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-200"
}
redis-mobilebot-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-201"
}
redis-offer-aggregator = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-202"
  param_group = "global-datastore-offer-aggregator-stagingumbz"
}

redis-orders = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-142"
}

redis-orders-dashboard = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-230"
}

redis-fraud = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-231"
}

redis-sportal-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-240"
}

redis-sportal-cache-dev = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-563"
}

redis-sportal-workers-sidekiq = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-242"
}

redis-sportal-workers-sidekiq-dev = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-564"
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

redis-goods-stores = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-282"
}

redis-ob-3rd-party-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-251"
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

redis-dealestate-configuration = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-270"
}

redis-dealestate-resque = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-271"
}

redis-eds = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-276"
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
  node_type = "cache.m6g.large"
  ticket = "RAAS-304"
}

redis-voucher-inventory = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-305"
}

redis-holmes-lovo-rvd = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-322"
}

redis-holmes-user-identities = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-328"
  oom_thresholds = "85:90"
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
redis-holmes-deals-rt-core-ranking = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-381"
  oom_thresholds = "90:94"
}
redis-holmes-deals-rt-dsp = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-383"
}

redis-watson-freshness = {
  create = true
  node_type = "cache.t4g.medium"
  num_nodes = 1
  ticket = "RAAS-325"
  autoscaling_min_nodes = 1
  autoscaling_max_nodes = 2
  autoscaling_mem_target = 80
}

redis-watson-user-kv = {
  create = true
  node_type = "cache.m6g.xlarge"
  num_nodes = 1
  ticket = "RAAS-326"
  oom_thresholds = "94:95"
}

redis-watson-user-kv-tmp = {
  create = false
  node_type = "cache.r6gd.xlarge"
  num_nodes = 2
  ticket = "RAAS-660"
  oom_thresholds = "94:97"
  snapshot_name = "watson-user-kv-staging-tmp"
}

redis-watson-search-kv = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-386"
}

redis-watson-deal-kv = {
  create = true
  node_type = "cache.r6g.large"
  num_nodes = 2
  ticket = "RAAS-327"
  oom_thresholds = "85:90"
}

redis-janus00 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus01 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus02 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus03 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus04 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus05 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus06 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus07 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus08 = {
  create = true
  node_type = "cache.t4g.medium"
  ticket = "RAAS-289"
}
redis-janus09 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus10 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus11 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus12 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus13 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus14 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
}
redis-janus15 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-289"
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

redis-test1 = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-330"
  snapshot_name = "test-im-lock01-for-datatier-manual"
}

redis-test3 = {
  create = false
  node_type = "cache.r6g.2xlarge"
  ticket = "RAAS-330"
  #snapshot_name = "datatier-backup-lock01-manual"
}

redis-relevance-sponsored-deals = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-375"
}

redis-rapi-pagination = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-389"
  num_nodes = 1
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

redis-vex = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-400"
}

redis-rm-user-resque = {
  create = false
  node_type = "cache.r6g.large"
  ticket = "RAAS-393"
}

redis-orders-cloud = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-440"
}

redis-goods-inventory-service = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 2
  ticket = "RAAS-471"
}

redis-search-backend = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-546"
}

redis-m3-merchant-service-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-602"
}

redis-getaways-inventory-product = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-654"
}

redis-test2 = {
  create = false
  node_type = "cache.r6gd.xlarge"
  ticket = "RAAS-665"
  num_nodes = 3
  snapshot_name = "automatic.watson-user-kv-staging-2022-07-08-08-00"
}

redis-m3-placeread = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-703"
  num_nodes = 1
}

redis-edrans-test = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1"
}

redis-pricing = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-811"
  num_nodes = 3
}

redis-mx = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-829"
}

redis-mx-reporting = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-843"
}

redis-wishlist = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-228"
}

redis-mls-rin = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-873"
}

redis-holmes-user-recent-searches = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-382"
}

redis-quantum-lead = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-609"
}

redis-rapi-citrus-ads = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1058"
}

redis-mobile-next = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-1077"
}

redis-editorial-writers = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-2637"
}

redis-ugc = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-303"
}

redis-ugc2 = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 1
  ticket = "RAAS-303"
}

redis-ugc-cache = {
  create = true
  node_type = "cache.t4g.medium"
  num_nodes = 2
  ticket = "RAAS-596"
}

redis-orders-conveyor = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-583"
}

redis-lazlo-deals = {
  create = true
  node_type = "cache.t4g.micro"
  num_nodes = 2
  ticket = "RAAS-250"
}

redis-vis = {
  create = true
  node_type = "cache.t4g.medium"
  num_nodes = 2
  ticket = "DATA-6765"
}

redis-supply-chain-gateway-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-203"
}

redis-rm-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-340"
  num_nodes = 2
}

redis-geo-bhuvan-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 2
}

redis-geo-bhuvan-geoms = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 2
}

redis-geo-bhuvan-indexer = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-306"
  num_nodes = 2
}

redis-incentive-cache = {
  create = true
  node_type = "cache.t4g.micro"
  ticket = "RAAS-286"
}