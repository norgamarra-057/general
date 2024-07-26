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
  cidr_block_list = ["10.216.67.0/25","10.216.67.128/25","10.216.68.0/25","10.216.64.0/25","10.216.64.128/25","10.215.130.0/23","10.215.128.0/23","10.0.0.0/8"]
 }
