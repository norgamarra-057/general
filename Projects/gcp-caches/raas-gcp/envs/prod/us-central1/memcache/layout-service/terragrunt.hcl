terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "memcache"
  )
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cache_name = "layout-service"
  memory_size = 3072
  node_count = 2
  cpu_count = 1
  labels = {
    service  = "layout-service"
    ticket = "raas-2421"
  }
}