terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "redis-cluster"
  )
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cache_name = "dlsvc-shield-cache"
  shard_count = 11
  node_type = "REDIS_HIGHMEM_MEDIUM"
  replica_count = 0
  labels = {
    service  = "deal-catalog"
    ticket = "raas-1115"
  }
}
