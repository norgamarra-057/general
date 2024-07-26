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
  		"../../../database/parameters/rds/14",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r5.large"
  local_replica_cnt   = "2"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version	  = "14"
  multi_az			  = false
  apply_immediately = true
  port				  = 5432
  db_name			  = "optimizely_data_listener_prod"
  storage_encrypted  = true
  kms_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_type = "io1"
  iops = 2500 
  replicate_source_db = ""
  max_allocated_storage = 4000
  allocated_storage = 2500
  cname = "optimizely-data-listener-prod"
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-34207"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "optimize@groupon.com"
  tenantservice_tag = "optimizely-data-listener"
}
