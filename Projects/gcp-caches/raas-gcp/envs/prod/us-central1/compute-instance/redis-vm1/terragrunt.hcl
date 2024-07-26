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
  vm_name = "redis-cli-vm"
  zone = "us-central1-a"
  machine_type = "e2-standard-4"
}