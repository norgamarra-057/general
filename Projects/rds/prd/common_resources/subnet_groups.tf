## US-WEST-1 Subnet Group
resource "aws_db_subnet_group" "dbsg_uswest1" {
  name       = "sgroup-1"
  provider   = "aws.uswest1"
  subnet_ids = "${var.region_to_subnets_map["us-west-1"]}"

  tags = {
    Name = "DB subnet group for the us-west-1 region"
  }
}

## EU-WEST-1 Subnet Group
resource "aws_db_subnet_group" "dbsg_euwest1" {
  name       = "sgroup-1"
  provider   = "aws.euwest1"
  subnet_ids = "${var.region_to_subnets_map["eu-west-1"]}"

  tags = {
    Name = "DB subnet group for the eu-west-1 region"
  }
}

