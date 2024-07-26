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
 }
