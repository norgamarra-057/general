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
  cache_name = "arbitration"
  shard_count = 3
  node_type = "REDIS_HIGHMEM_MEDIUM"
  replica_count = 0
  labels = {
    service  = "arbitration-service"
    ticket = "raas-2365"
  }
}