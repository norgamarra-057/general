generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}
provider "aws" {
  region = "us-west-1"
  profile = "dev"
}
EOF
}
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # bucket name must be unique
    bucket = "raas-terraform-state-dev-usw1"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-west-1"
    encrypt = true
    dynamodb_table = "raas-terraform-lock"

    s3_bucket_tags = {
      Owner = "raas-team@groupon.com"
      Service = "raas"
      Name  = "RaaS Terraform state storage"
    }

    dynamodb_table_tags = {
      Owner = "raas-team@groupon.com"
      Service = "raas"
      Name  = "RaaS Terraform lock table"
    }
  }
}
