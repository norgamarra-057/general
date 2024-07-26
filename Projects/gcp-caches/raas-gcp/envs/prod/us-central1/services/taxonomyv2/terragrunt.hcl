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
  cache_name = "taxonomyv2"
  memory_size = 4
  labels = {
    service  = "taxonomyv2"
    ticket = "raas-1112"
  }
}