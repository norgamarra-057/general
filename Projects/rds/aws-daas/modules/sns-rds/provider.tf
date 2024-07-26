provider "aws" {
  region = var.aws_region
}


#provider "aws" {
#  region = var.aws_region
#  alias = "primary_region"
#}

#provider "aws" {
#  region = var.remote_region
#  alias = "remote_region"
#}

terraform {
  required_version = "0.12.31"
  backend "s3" {}
}
