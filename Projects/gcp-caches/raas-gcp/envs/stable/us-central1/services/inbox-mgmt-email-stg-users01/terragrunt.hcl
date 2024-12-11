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
  cache_name = "inbox-mgmt-email-stg-users01"
  memory_size = 5
  labels = {
    owner = "raas"
    service = "raas_redis_instance"
    tenantservice = "inbox_management_platform"
    ticket = "raas-1963"
  }
}