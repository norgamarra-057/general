terraform {
  source = "git::https://github.groupondev.com/data/raas_terraform_modules.git//redis?ref=e53c631"
  extra_arguments "vpc_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    required_var_files = [
      "${get_terragrunt_dir()}/../raas.tfvars",
      "${get_terragrunt_dir()}/../vpc.tfvars"
    ]
  }
}
include {
  path = "${find_in_parent_folders()}"
}
