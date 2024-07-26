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
  cache_name = "dispatcher-cache"
  shard_count = 3
  node_type = "REDIS_HIGHMEM_MEDIUM"
  replica_count = 0
  labels = {
    service  = "rocketman-commercial"
    ticket = "raas-2351"
  }
}
