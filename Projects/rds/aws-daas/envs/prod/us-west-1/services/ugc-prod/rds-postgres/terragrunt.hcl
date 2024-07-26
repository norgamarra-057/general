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
  instance_type       = "db.r5.xlarge"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version	  = "11.19"
  multi_az			  = false
  port				  = 5432
  db_name			  = "marketplace_ugc_prod"
  replicate_source_db = ""
  storage_type     = "gp2"
  max_allocated_storage = 3000
  allocated_storage = 2000
  account_id  = get_aws_account_id()
  apply_immediately = "true"
  cname = "ugc-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-30482"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "ugc-dev@groupon.com"
  tenantservice_tag = "ugc-async"
}
