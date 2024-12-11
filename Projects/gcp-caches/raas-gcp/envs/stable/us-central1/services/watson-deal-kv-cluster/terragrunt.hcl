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
  cache_name = "watson-deal-kv-cluster"
  shard_count = 3
  node_type = "REDIS_SHARED_CORE_NANO"
  replica_count = 0
  labels = {
    owner = "raas"
    service = "raas_redis_cluster"
    tenantservice = "watson-api"
    ticket = "raas-2440"
  }
}