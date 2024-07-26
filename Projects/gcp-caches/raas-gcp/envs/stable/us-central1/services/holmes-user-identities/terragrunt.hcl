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
  cache_name = "holmes-user-identities"
  memory_size = 2
  labels = {
    service  = "watson-api"
    ticket = "raas-2440"
  }
}