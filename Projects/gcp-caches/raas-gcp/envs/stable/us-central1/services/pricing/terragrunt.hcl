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
  cache_name = "pricing"
  memory_size = 2
  labels = {
    service  = "pricing_service"
    ticket = "raas-2336"
  }
}