terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "redis-instance"
  )
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cache_name = "norber-redis-test1"
  memory_size = 2
  service_tier = "STANDARD_HA"
  replica_count = 1
  labels = {
    service  = "accounting-service"
    ticket = "raas-1055"
  }
}
