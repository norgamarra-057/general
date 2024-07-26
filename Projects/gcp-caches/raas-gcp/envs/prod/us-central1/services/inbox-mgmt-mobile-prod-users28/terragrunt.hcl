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
  cache_name = "inbox-mgmt-mobile-prod-users28"
  memory_size = 5
  labels = {
    service  = "inbox_management_platform"
    ticket = "raas-1964"
  }
}