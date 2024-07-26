terraform {
    source = "../../../../../..//modules/rds-postgres"
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
  instance_type       = "db.r6g.large"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  db_name			  = "campaign_perform_prod"
  replicate_source_db = ""
  apply_immediately = true
  cname = "campaign-perform-prod"
  max_allocated_storage = 2000
  allocated_storage = 1000
  kms_key_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-31968"
  service_tag = "daas_postgres"
  owner_tag = "GDS"
  tenantteam_tag = "pmp-engineering@groupon.com"
  tenantservice_tag = "campaign_performance"
}
