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
  cache_name = "occasions"
  memory_size = 2048
  node_count = 6
  cpu_count = 1
  labels = {
    service  = "occasions"
    ticket = "raas-1823"
  }
}