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
  		"../../../database/parameters/rds/10",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r5.large"
  local_replica_cnt   = 1 
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  db_name			  = "pg_core_emea_582_stg"
  engine			  = "postgres"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  storage_type     = "gp3"
  iops = 12000
  allocated_storage = 500
  max_allocated_storage = 1500
  iops = 12000
  apply_immediately = true
  account_id  = get_aws_account_id()
  cname = "pg-core-emea-582-stg"
  performance_insights_enabled = true
  maintenance_window  = "mon:00:00-mon:03:00" 
  backup_retention_period = 7
##  replicate_source_db  = "arn:aws:rds:us-west-1:286052569778:db:custom-fields-stg"
  jira_tag = "GDS-25134"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
