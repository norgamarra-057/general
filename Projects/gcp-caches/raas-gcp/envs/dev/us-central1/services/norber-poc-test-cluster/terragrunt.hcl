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
  cache_name = "norber-redis-test-cluster"
  memory_size = 16
  service_tier = "STANDARD_HA"
  shard_count = 5
  replica_count = 1
}
