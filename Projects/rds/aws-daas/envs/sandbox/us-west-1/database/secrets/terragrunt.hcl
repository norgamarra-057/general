  terraform {
    source = "../../../../../modules/secrets"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = []
  }

  inputs = {
    owner_tag = "gds@groupon.com"
    service_tag = "daas_mysql:daas_postgres"
    tenantteam_tag = "gds@groupon.com"
  }
