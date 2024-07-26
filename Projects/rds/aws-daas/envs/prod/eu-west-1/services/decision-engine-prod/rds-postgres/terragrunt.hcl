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
  instance_type       = "db.t3.large"
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "small"
  engine_version	  = "11.15"
  allocated_storage = 50
  max_allocated_storage   = 1024
  multi_az			  = false
  apply_immediately = true 
  port				  = 5432
  db_name			  = "decision_engine_prod"
  cname = "decision-engine-prod"
  performance_insights_enabled    = true
  account_id = get_aws_account_id()
  jira_tag = "GDS-29761"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "pmp-engineering@groupon.com"
  tenantservice_tag = "decision-engine"

}
