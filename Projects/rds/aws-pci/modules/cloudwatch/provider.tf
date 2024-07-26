provider "aws" {
  version = "~> 3.66"
  region  = var.aws_region
}

terraform {
  required_version = "0.12.31"
  backend "s3" {}
}
