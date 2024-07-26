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
  cache_name = "deal-estate-resque"
  memory_size = 1
  labels = {
    service  = "deal-estate"
    ticket = "raas-1278"
  }
}