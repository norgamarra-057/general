  terraform {
    source = "../../../../../../../modules/database-common/parameters/rds"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = []
  }

  inputs = {
    db_parameter_family = "postgres11"
  }

