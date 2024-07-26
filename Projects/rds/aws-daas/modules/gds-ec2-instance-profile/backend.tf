// Every¸Terraform module that is used with Terragrunt, needs this empty backend definition.
// The backend will be automatically configured by Terragrunt

terraform {
  backend "s3" {}
}
