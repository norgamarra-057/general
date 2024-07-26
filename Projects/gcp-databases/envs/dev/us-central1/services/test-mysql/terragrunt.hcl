terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "database-instance"
  )
}

include {
  path = find_in_parent_folders()
}


inputs = {
  db_name = "mcarreno-test-db"
  db_instance_name = "mcarreno-test-instance"
  db_version = "MYSQL_8_0"
  db_tier = "db-f1-micro"
}
