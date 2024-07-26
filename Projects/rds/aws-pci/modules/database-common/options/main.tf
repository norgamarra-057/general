resource "aws_db_option_group" "default" {
  name                 = "daas-option-group"
  engine_name          = "${var.engine}"
  major_engine_version = "${var.major_engine_version}"
  option               = "${var.db_options}"

  lifecycle {
    create_before_destroy = true
  }
}


################################################
# Backend management
################################################
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

