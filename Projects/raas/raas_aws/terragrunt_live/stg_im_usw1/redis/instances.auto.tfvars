redis-inbox-mgmt-email-stg-users01 = {
  create = true
  node_type = "cache.r6g.large"
  ticket = "RAAS-866"
}

redis-inbox-mgmt-mobile-stg-users01 = {
  create = true
  node_type = "cache.t4g.small"
  ticket = "RAAS-866"
  oom_thresholds = "80:90"
}