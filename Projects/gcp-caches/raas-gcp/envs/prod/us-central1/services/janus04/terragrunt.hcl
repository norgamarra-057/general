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
  cache_name = "janus04"
  memory_size = 3
  labels = {
    owner = "raas"
    service = "raas_redis_instance"
    tenantservice = "janus"
    ticket = "raas-1123"
  }
}