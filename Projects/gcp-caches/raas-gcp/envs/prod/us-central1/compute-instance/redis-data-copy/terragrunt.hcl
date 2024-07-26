terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "compute-instance"
  )
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vm_name = "redis-data-copy"
  machine_type = "e2-highmem-8"
  zone = "us-central1-a"
}