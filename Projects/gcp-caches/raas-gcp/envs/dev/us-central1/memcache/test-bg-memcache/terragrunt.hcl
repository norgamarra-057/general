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
  cache_name = "test-bg-memcache"
  memory_size = 1024
  node_count = 1
  cpu_count = 1

  project_dnszone="dz-dev-sharedvpc01-us-central1-caches-dev"
  labels = {
    service  = "test-bg-memcache-service"
    ticket = "raas-xxx"
  }
}