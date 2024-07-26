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
  cache_name = "watson-deal-kv"
  shard_count = 3
  node_type = "REDIS_STANDARD_SMALL"
  replica_count = 0
  labels = {
    service  = "watson-api"
    ticket = "raas-1152"
  }
}
