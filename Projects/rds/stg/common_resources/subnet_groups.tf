## US-WEST-1 Subnet Group
resource "aws_db_subnet_group" "dbsg_uswest1" {
  name       = "sgroup-1"
  provider   = "aws.uswest1"
  subnet_ids = "${var.region_to_subnets_map["us-west-1"]}"

  tags = {
    Name = "DB subnet group for the us-west-1 region"
  }
}

## US-WEST-2 Subnet Group
resource "aws_db_subnet_group" "dbsg_uswest2" {
  name       = "sgroup-1"
  provider   = "aws.uswest2"
  subnet_ids = "${var.region_to_subnets_map["us-west-2"]}"

  tags = {
    Name = "DB subnet group for the us-west-2 region"
  }
}

