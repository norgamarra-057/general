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
  cache_name = "fraud"
  memory_size = 3
  labels = {
    service  = "orders"
    ticket = "raas-2465"
  }
}