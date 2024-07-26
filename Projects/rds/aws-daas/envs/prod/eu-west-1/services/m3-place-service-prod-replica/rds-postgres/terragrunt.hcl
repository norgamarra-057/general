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
  size                = "large"
  engine_version	  = "11.19"
  multi_az			  = false 
  port				  = 5432
  db_name			  = "m3_place_service_prod"
  cname = "m3-place-service-prod"
  replicate_source_db = "arn:aws:rds:us-west-1:497256801702:db:m3-place-service-prod"
  storage_type     = "gp2"
  max_allocated_storage = 4000
  allocated_storage = 2500
  kms_key_id = "arn:aws:kms:eu-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  account_id  = get_aws_account_id()
  apply_immediately = "true"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-31717"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "merchantdata@groupon.com"
  tenantservice_tag = "m3_placewrite"
}
