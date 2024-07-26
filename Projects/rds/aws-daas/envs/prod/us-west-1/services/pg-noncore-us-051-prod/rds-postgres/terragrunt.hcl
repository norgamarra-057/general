terraform {
    source = "../../../../../../modules/rds-postgres"
}

include {
	path = find_in_parent_folders()
}

dependencies {
	paths = [
  		"../../../database/networking",
#     	"../../../database/options",
  		"../../../database/parameters/rds/11",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r5.4xlarge"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version          = "11.22"
  multi_az			  = false
  port				  = 5432
  db_name			  = "pg_noncore_us_051_prod"
  replicate_source_db = ""
  max_allocated_storage = 9000
  storage_type = "io1"
  iops = 7000
  apply_immediately = true
  backup_retention_period = 15
  allocated_storage = 3999
  performance_insights_enabled = true
  cname = "pg-noncore-us-051-prod"
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-25138"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
