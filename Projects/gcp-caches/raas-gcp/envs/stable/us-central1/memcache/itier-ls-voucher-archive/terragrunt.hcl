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
  cache_name = "itier-ls-voucher-archive"
  memory_size = 1024
  node_count = 1
  cpu_count = 1
  labels = {
    owner = "raas"
    service = "raas_memcached"
    tenantservice = "itier-ls-voucher-archive"
    ticket = "raas-1242"
  }
}