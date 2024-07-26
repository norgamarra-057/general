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
  cache_name = "custsvc-cache"
  memory_size = 2
  labels = {
    service  = "cyclops"
    ticket = "raas-1799"
  }
}