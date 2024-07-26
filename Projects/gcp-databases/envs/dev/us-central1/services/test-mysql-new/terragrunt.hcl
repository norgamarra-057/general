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
  db_name = "moosa-test-db-terra"
  db_instance_name = "moosa-test-instance-terra"
  #db_replica_name = "moosa-test-instance-terra-replica"
  db_version = "MYSQL_8_0"
  db_tier = "db-custom-4-15360"
  #disk_size=500
  wait_timeout=20000
  general_log="off"
  max_connections=2000
  log_output="FILE"
  #long_query_time=1.2
  replica_count = 2
}
