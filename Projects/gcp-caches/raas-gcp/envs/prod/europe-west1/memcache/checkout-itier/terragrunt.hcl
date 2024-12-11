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
  cache_name = "checkout-itier"
  memory_size = 1024
  node_count = 1
  cpu_count = 1
  labels = {
    owner = "raas"
    service = "raas_memcached"
    tenantservice = "checkout-itier"
    ticket = "raas-2324"
  }
}