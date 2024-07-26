// Two differently configured EC2 instances

module "ec2_instance_a" {
  source     = "git::https://github.groupondev.com/terraform-modules/ec2.git//instance?ref=v1.0.0"
  owner      = "dminor@groupon.com"
  usage      = "GDS::AWS-DaaS"
  aws_region = "${var.aws_region}"
  name       = "test-A-dminor"

  // a micro instance
  instance_type = "t2.micro"
}

module "ec2_instance_b" {
  source     = "git::https://github.groupondev.com/terraform-modules/ec2.git//instance?ref=v1.0.0"
  owner      = "dminor@groupon.com"
  usage      = "GDS::AWS-DaaS"
  aws_region = "${var.aws_region}"
  name       = "test-B-dminor"

  // a nano instance
  instance_type = "t3.nano"
}
