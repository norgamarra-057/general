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
  cache_name = "getaways-search-cache"
  memory_size = 10
  labels = {
    service  = "travel-search"
    ticket = "raas-2039"
  }
}