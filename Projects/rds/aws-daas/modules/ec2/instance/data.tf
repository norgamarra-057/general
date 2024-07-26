data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc]
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.aws_region}${var.availability_zone}-${var.tier}Subnet"
    Tier = var.tier
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "default"
}

data "aws_ami" "default" {
  most_recent = true
  owners = ["286052569778"]
  filter {
    name   = "name"
    values = ["GDS_PACKER_AMI"]
  }
}
