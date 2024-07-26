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
  cache_name = "killbill"
  memory_size = 1
  labels = {
    service  = "killbill-payments"
    ticket = "raas-1796"
  }
}