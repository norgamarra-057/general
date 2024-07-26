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
  cache_name = "goods-market-pricing"
  memory_size = 1
  labels = {
    service  = "goods-market-pricing"
    ticket = "raas-1867"
  }
}