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
  cache_name = "layout-service-templates"
  memory_size = 3
  labels = {
    service  = "layout-service"
    ticket = "raas-2421"
  }
}