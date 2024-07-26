  terraform {
    source = "../../../../../../../modules/database-common/parameters/aurora"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = []
  }

  inputs = {
	db_parameter_family = "aurora-mysql8.0"
  }
