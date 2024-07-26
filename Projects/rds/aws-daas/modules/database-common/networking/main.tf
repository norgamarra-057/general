data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.lz_vpc_name}"]
  }
}

data "aws_subnet_ids" "db_subnet_ids" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags = {
    Name = "*-DBSubnet"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "sgroup-1"
  subnet_ids = data.aws_subnet_ids.db_subnet_ids.ids
}



################################################
# Backend management
################################################
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}
