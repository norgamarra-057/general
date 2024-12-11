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
  cache_name = "raas-instance-test"
  memory_size = 1
  labels = {
    service  = "raas"
    ticket = "raas-1111"
  }
}