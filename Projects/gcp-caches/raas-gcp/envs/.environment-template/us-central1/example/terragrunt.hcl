terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "gcp-example"
  )
}

include {
  path = find_in_parent_folders()
}
