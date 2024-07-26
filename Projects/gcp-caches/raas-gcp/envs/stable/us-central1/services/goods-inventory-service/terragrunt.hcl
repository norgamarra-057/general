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
  cache_name = "goods-inventory-service"
  memory_size = 3
  labels = {
    service  = "goods-inventory-service"
    ticket = "raas-2075"
  }
}