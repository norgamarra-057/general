terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "gds-instance-dns"
  )
}

include {
  path = find_in_parent_folders()
}