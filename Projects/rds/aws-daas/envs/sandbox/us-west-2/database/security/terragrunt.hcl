  terraform {
    source = "../../../../../modules/database-common/security"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  #prevent_destroy = true

  dependencies {
    paths = []
  }

 inputs = {
  cidr_block_list = ["10.224.67.0/25","10.224.67.128/25","10.224.68.0/25","10.224.64.0/25","10.224.64.128/25","10.224.65.0/25","10.223.128.0/23","10.223.130.0/23","10.223.132.0/23","10.0.0.0/8"]
 }
