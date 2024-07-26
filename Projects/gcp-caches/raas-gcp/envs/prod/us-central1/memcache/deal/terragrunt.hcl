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
  cache_name = "deal"
  memory_size = 1024
  node_count = 1
  cpu_count = 1
  labels = {
    service  = "deal"
    ticket = "raas-2350"
  }
}