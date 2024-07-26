terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "database-instance/postgres"
  )
}

include {
  path = find_in_parent_folders()
}


