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
  cache_name = "watson-user-kv"
  shard_count = 9
  node_type = "REDIS_HIGHMEM_MEDIUM"
  replica_count = 0
  labels = {
    service  = "watson-api"
    ticket = "raas-1152"
  }
}
