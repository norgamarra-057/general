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
  instance_type       = "db.t3.medium"
  local_replica_cnt   = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pg_noncore_emea_999_stg"
  engine			  = "postgres"
  engine_version	  = "11.21"
  multi_az			  = false
  port				  = 5432
  storage_type     = "gp3"
  allocated_storage = 1000
  apply_immediately = "true"
  max_allocated_storage = 1500
  account_id  = get_aws_account_id()
  cname = "pg-noncore-emea-999-stg"
  performance_insights_enabled = true
  maintenance_window  = "mon:00:00-mon:03:00" 
  backup_retention_period = 7
##  replicate_source_db  = "arn:aws:rds:us-west-1:286052569778:db:custom-fields-stg"
  jira_tag = "GDS-25128"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
