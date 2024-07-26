terragrunt = {
  terraform {
    source = "../../../../../modules//database-common/options"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = []
  }
}

