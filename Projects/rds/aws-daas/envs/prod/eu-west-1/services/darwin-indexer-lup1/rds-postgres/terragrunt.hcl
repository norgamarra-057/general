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
  allocated_storage = 4000
  max_allocated_storage   = 6000
  multi_az			  = false
  apply_immediately = true 
  port				  = 5432
  db_name			  = "darwin_indexer_prod"
  cname = "darwin-indexer-lup1"
  performance_insights_enabled    = true
  account_id = get_aws_account_id()
  jira_tag = "GDS-32476"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "goods-cxx-dev@groupon.com"
  tenantservice_tag = "relevance"

}
