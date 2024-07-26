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
  cache_name = "watson-freshness"
  shard_count = 5
  node_type = "REDIS_HIGHMEM_XLARGE"
  replica_count = 0
  labels = {
    service  = "watson-api"
    ticket = "raas-2441"
  }
}
