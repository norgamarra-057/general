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
  instance_type       = "db.r5.large"
  local_replica_cnt   = "0"
  local_subnet_group  = "default-vpc-0a38df8f4ac2b624c"
  size                = "small"
  engine_version          = "11.19"
  multi_az                        = false
  port				  = 5432
  db_name			  = "metro_draft_prod"
  replicate_source_db = ""
  max_allocated_storage = 1024
  allocated_storage = 50
  account_id  = get_aws_account_id()
  cname = "metro-draft-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-28704"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "metro-dev-blr@groupon.com"
  tenantservice_tag = "draft-service"
}
