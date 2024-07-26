data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.lz_vpc_name]
  }
}

# Secondary region
data "aws_vpc" "vpc_sec" {
  provider = aws.secregion
  filter {
    name   = "tag:Name"
    values = [var.lz_vpc_sec_name]
  }
}

data "aws_subnet_ids" "conveyor" {
  vpc_id        = data.aws_vpc.vpc.id
  filter {
    name   = "tag:used-by-conveyor"
    values = ["1"]
  }
}

# Secondary region
data "aws_subnet_ids" "conveyor_sec" {
  provider = aws.secregion
  vpc_id        = data.aws_vpc.vpc_sec.id
  filter {
    name   = "tag:used-by-conveyor"
    values = ["1"]
  }
}

data "aws_subnet" "conveyor_cidr" {
  for_each = data.aws_subnet_ids.conveyor.ids
  id       = each.value
}

# Secondary region
data "aws_subnet" "conveyor_sec_cidr" {
  provider = aws.secregion
  for_each = data.aws_subnet_ids.conveyor_sec.ids
  id       = each.value
}
