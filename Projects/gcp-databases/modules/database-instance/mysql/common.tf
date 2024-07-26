# Add common resources used by all tf modules here

# Placeholder for terraform state backend - details are populated by terragrunt
terraform {
  backend "gcs" {}
}

# Variables
variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform"
  type        = string
  default     = ""
}

variable "env_stage" {
  description = "Stage (dev, stable, prod) of the environment"
  type        = string
}

#variable "gcp_project_id" {
#  description = "GCP project id where resources will be applied."
#}

locals {
  sa_project_stage = {
    # This ensures that any service project will only use SAs that live in the
    # equivalent stage central-sa project.
    sandbox = "prj-grp-central-sa-dev-e453"
    dev     = "prj-grp-central-sa-dev-e453"
    stable  = "prj-grp-central-sa-stable-66eb"
    prod    = "prj-grp-central-sa-prod-0b25"
  }

  use_tf_sa = var.terraform_service_account != "" || contains(["stable", "prod"], var.env_stage)

  tf_sa = join(
    "",
    [
      var.terraform_service_account,
      "@",
      lookup(local.sa_project_stage, var.env_stage),
      ".iam.gserviceaccount.com"
    ]
  )
}

# Provider definition
provider "google" {
  alias = "impersonate"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  count                  = local.use_tf_sa ? 1 : 0
  provider               = google.impersonate
  target_service_account = local.tf_sa
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "3600s"
}

/******************************************
  Provider credential configuration
 *****************************************/
provider "google" {
  access_token = local.use_tf_sa ? data.google_service_account_access_token.default[0].access_token : null
}

provider "google-beta" {
  access_token = local.use_tf_sa ? data.google_service_account_access_token.default[0].access_token : null
}
