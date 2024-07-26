remote_state {
  backend = "gcs"

  # Keep the resource names in base_environment/../terraform_state.tf and envs/terraform.tfvars in sync
  config = {
    bucket = "grpn-gcp-${get_env("TF_VAR_PROJECTNAME", "INVALID")}-state-${get_env("TF_VAR_GCP_PROJECT_NUMBER", "INVALID")}"
    prefix = "${path_relative_to_include()}"

    project  = "${get_env("TF_VAR_GCP_PROJECT_ID", "INVALID")}"
    location = "US"

    # Comment out the impersonate_service_account section if not using a terraform deployment SA
    impersonate_service_account = join(
      "@",
      [
        local.terraform_service_account,
        lookup(
          local.central_service_account_projects,
          get_env("TF_VAR_GCP_ENV_STAGE", "INVALID")
        )
      ]
    )
  }
}

locals {
  terraform_service_account = "grpn-sa-terraform-gds"
  central_service_account_projects = {
    dev    = "prj-grp-central-sa-dev-e453.iam.gserviceaccount.com"
    stable = "prj-grp-central-sa-stable-66eb.iam.gserviceaccount.com"
    prod   = "prj-grp-central-sa-prod-0b25.iam.gserviceaccount.com"
  }
}

# Allow us to specify some environment specific files in "env_vars.tfvars"
# Things we'd put there include settings that are common across the entire
# environment structure, such as
# aws_vpc_domain_name = "gensandbox.aws.groupondev.com"
# which is constant across all things in the general sandbox.
terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      "${get_parent_terragrunt_dir()}/global.hcl",
      find_in_parent_folders("account.hcl"),
      find_in_parent_folders("region.hcl", find_in_parent_folders("account.hcl")), "variables.hcl"
    ]
  }

  extra_arguments "warning_summarize" {
    commands = [
      "plan",
      "apply",
      "destroy"
    ]

    arguments = ["-compact-warnings"]
  }

  extra_arguments "destroy_auto_approval" {
    commands = [
      "destroy"
    ]

    arguments = ["-auto-approve"]
  }

  after_hook "after_hook_plan" {
    commands = ["plan"]
    execute  = ["sh", "-c", "terraform show -json plan.output > plan.json"]
  }
}

# Generate common tf in modules
generate "common" {
  path      = "common.tf"
  if_exists = "skip"
  contents  = file("${get_parent_terragrunt_dir()}/../modules/template/common.tf")
}
