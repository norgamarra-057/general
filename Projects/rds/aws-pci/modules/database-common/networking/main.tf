data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.lz_vpc_name}"]
  }
}

data "aws_subnet_ids" "db_subnet_ids" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  filter {
    name   = "tag:Name"
    values = ["db-*"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "sgroup-1"
  subnet_ids = data.aws_subnet_ids.db_subnet_ids.ids
}

