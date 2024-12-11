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
  shard_count = 5
  node_type = "REDIS_STANDARD_SMALL"
  replica_count = 0
  labels = {
    owner = "raas"
    service = "raas_redis_cluster"
    tenantservice = "rocketman-commercial"
    ticket = "raas-2355"
  }
}