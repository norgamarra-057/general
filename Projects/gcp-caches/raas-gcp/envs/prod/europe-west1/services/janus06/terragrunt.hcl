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
  cache_name = "janus06"
  memory_size = 3
  labels = {
    owner = "raas"
    service = "raas_redis_instance"
    tenantservice = "janus-realtime"
    ticket = "raas-1125"
  }
}