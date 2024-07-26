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
  cache_name = "rm-cache"
  shard_count = 3
  node_type = "REDIS_SHARED_CORE_NANO"
  replica_count = 0
  labels = {
    service  = "rocketman_v2"
    ticket = "raas-2349"
  }
}