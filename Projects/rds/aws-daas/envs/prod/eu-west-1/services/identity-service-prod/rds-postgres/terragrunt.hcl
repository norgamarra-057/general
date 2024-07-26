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
  local_subnet_group  = "sgroup-1"
  size                = "small"
  engine_version          = "11.19"
  allocated_storage = 500
  max_allocated_storage   = 2048
  multi_az			  = false
  apply_immediately    = true 
  port				  = 5432
  db_name			  = "identity_service_prod"
  performance_insights_enabled    = true
  account_id = get_aws_account_id()
  jira_tag = "GDS-31792"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "users-team@groupon.com"
  tenantservice_tag = "identity-service"

}
