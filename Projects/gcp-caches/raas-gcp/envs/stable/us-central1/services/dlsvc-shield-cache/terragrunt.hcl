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
  cache_name = "dlsvc-shield-cache"
  memory_size = 10
  labels = {
    service  = "deal-catalog"
    ticket = "raas-1114"
  }
}