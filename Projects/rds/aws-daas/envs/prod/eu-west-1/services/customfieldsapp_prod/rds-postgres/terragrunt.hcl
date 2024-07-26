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
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine_version	  = "11.22"
  allocated_storage = 50
  max_allocated_storage   = 1024
  multi_az			  = false
  apply_immediately   = true 
  port				  = 5432
  db_name			  = "customfieldapp_prod"
  performance_insights_enabled    = true
  replicate_source_db = "arn:aws:rds:us-west-1:497256801702:db:customfieldapp-prod"
  account_id = get_aws_account_id()
  jira_tag = "GDS-19967"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "3pip-cfs@groupon.com"
  tenantservice_tag = "custom-fields-service"

#  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:customfieldsapp-prod"
#  arn  = "arn:aws:rds:us-west-1:497256801702:db:customfieldsapp-prod"
}
