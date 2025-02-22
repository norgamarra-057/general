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
  instance_type       = "db.r5.2xlarge"
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine_version          = "11.19"
  multi_az			  = false
  port				  = 5432
  db_name			  = "pg_noncore_us_055_prod"
  apply_immediately = true
  replicate_source_db = ""
  max_allocated_storage = 4000
  backup_retention_period = 15
  allocated_storage = 1000
  storage_encrypted = true
  cname = "pg-noncore-us-055-prod"
  performance_insights_enabled = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-30284"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
