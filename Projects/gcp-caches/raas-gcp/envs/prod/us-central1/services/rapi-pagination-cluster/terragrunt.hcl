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
  cache_name = "rapi-pagination"
  shard_count = 3
  node_type = "REDIS_STANDARD_SMALL"
  replica_count = 0
  labels = {
    service  = "relevance"
    ticket = "raas-1135"
  }
}
