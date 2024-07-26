terraform {
  source = "git::https://github.groupondev.com/data/raas_terraform_modules.git//redis?ref=dfa6393"
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
  after_hook "raas" {
    commands = ["apply", "plan"]
    execute = ["bash", "--login", "-c", "cd ${get_terragrunt_dir()}/../../../tf_afterhook/ && ./hook.rb ${get_terragrunt_dir()}"]
    run_on_error = false
  }
}
include {
  path = "${find_in_parent_folders()}"
}
