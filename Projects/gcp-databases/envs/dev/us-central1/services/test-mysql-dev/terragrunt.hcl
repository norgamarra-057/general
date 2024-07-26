terraform {
  source = run_cmd(
    "${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
    "database-instance/mysql"
  )
}

include {
  path = find_in_parent_folders()
}


inputs = {
  db_name = "stable-db-terraform"
  db_instance_name = "stable-db-terraform"
  db_replica_name = "stable-db-terraform-replica"
  db_version = "MYSQL_5_7"
  db_tier = "db-custom-4-15360"
}
