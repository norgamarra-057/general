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
  cache_name = "proximity-cache"
  memory_size = 1
  labels = {
    service  = "proximity_notifications"
    ticket = "raas-1423"
  }
}