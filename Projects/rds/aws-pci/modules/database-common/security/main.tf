################################################
# Backend management
################################################
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_security_group" "sgdaas" {
  name          = "sgdaas"
  description   = "allow connections on port 3306"
  vpc_id        = data.aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat([for s in data.aws_subnet.conveyor_cidr : s.cidr_block],[for t in data.aws_subnet.conveyor_sec_cidr : t.cidr_block],["10.0.0.0/8"])
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = concat([for s in data.aws_subnet.conveyor_cidr : s.cidr_block],[for t in data.aws_subnet.conveyor_sec_cidr : t.cidr_block],["10.0.0.0/8"])
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
