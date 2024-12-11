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
  cache_name = "targeted-deal-message-cache"
  memory_size = 3
  labels = {
    owner = "raas"
    service = "raas_redis_instance"
    tenantservice = "targeted-deal-message"
    ticket = "raas-1723"
  }
}