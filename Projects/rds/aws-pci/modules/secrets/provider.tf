variable "aws_region" {
  description = "Which AWS region the instance is in"
}

provider "aws" {
  version = "~> 3.66"
  region  = var.aws_region
}

terraform {
  required_version = "0.12.31"
  backend "s3" {}
}
