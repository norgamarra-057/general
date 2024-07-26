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
  cache_name = "janus03"
  memory_size = 3
  labels = {
    service  = "janus"
    ticket = "raas-1123"
  }
}