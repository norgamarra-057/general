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
  cache_name = "ugc-cache"
  memory_size = 3
  labels = {
    service  = "ugc-api-jtier"
    ticket = "raas-1882"
  }
}