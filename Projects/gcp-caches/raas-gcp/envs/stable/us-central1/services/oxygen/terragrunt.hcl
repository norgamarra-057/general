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
  cache_name = "oxygen"
  memory_size = 1
  labels = {
    service  = "jtier-oxygen"
    ticket = "raas-1226"
  }
}