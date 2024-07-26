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
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "medium"
  db_name       = "campaign_perform_prod"
  cname = "campaign-perform-prod"
  engine_version          = "14.7"
  multi_az			  = false
  apply_immediately = true 
  port				  = 5432
  allocated_storage = 1000
  max_allocated_storage = 2000
  account_id = get_aws_account_id()
  replicate_source_db = "arn:aws:rds:us-west-1:497256801702:db:campaign-perform-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  kms_key_id = "arn:aws:kms:eu-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  cluster_master_arn  = ""
  performance_insights_enabled    = true
  jira_tag = "GDS-31967"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "pmp-engineering@groupon.com"
  tenantservice_tag = "campaign_performance"
}
