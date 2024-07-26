terraform_binary = "/usr/local/bin/terraform"

  remote_state {
    backend = "s3"

    # Keep the resource names in base_environment/../terraform_state.tf and envs/terraform.tfvars in sync
    config = {
      bucket         = "grpn-gds-pci-daas-mysql-state-${get_aws_account_id()}"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "us-west-1"
      encrypt        = true
      dynamodb_table = "grpn-gds-pci-daas-mysql-lock-table-${get_aws_account_id()}"
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

      # Order for how tfvars files are loaded is important. If same var is set in multiple tfvars, the tfvars loaded last takes precedence
      # https://www.terraform.io/docs/configuration-0-11/variables.html#variable-precedence
      # Loading account wide tfvars first, service-specific tfvars last
      optional_var_files = [
        "${get_terragrunt_dir()}/${find_in_parent_folders("account-level.tfvars")}",
        "${get_terragrunt_dir()}/${find_in_parent_folders("region-level.tfvars")}",
        "${get_terragrunt_dir()}/${find_in_parent_folders("common-level.tfvars")}",
        "${get_terragrunt_dir()}/../service-specific.tfvars",
        "${get_terragrunt_dir()}/module-specific.tfvars",
      ]
    }
  }
