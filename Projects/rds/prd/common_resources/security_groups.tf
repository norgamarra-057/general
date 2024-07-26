resource "aws_security_group" "sg_prd_na" {
  provider      = "aws.uswest1"
  name          = "secgroup-prd-na"
  description   = "allow connections on port 3306"
  vpc_id        = "${var.region_to_vpcid_map["us-west-1"]}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_prd_emea" {
  provider      = "aws.euwest1"
  name          = "secgroup-prd-emea"
  description   = "allow connections on port 3306"
  vpc_id        = "${var.region_to_vpcid_map["eu-west-1"]}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "sg_prd_na_secgroup_id" {
  value = "${aws_security_group.sg_prd_na.id}"
}

output "sg_prd_emea_secgroup_id" {
  value = "${aws_security_group.sg_prd_emea.id}"
}
