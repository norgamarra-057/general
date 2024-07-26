  terraform {
    source = "../../../../../modules/database-common/networking"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = []
  }
