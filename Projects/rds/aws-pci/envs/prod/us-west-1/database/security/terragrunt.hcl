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
  cidr_block_list = ["10.14.4.51/32","10.14.2.13/32","10.14.2.79/32","10.14.5.137/32","10.21.3.22/32","10.21.3.21/32","10.14.5.178/32","10.14.2.65/32","10.14.2.29/32","10.14.2.24/32","10.14.5/13/32","10.14.2./103/32","10.14.4.52/32"]
 }
