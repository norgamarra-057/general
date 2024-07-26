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
  instance_type       = "db.r5.2xlarge"
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  # engine_version	  = "11.15"
  engine_version          = "11.19"
  multi_az			  = false
  port				  = 5432
  db_name			  = "backbeat_pg"
  apply_immediately = true
  replicate_source_db = ""
  max_allocated_storage = 10500
  allocated_storage = 8000
  kms_key_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  cname = "backbeat-acct-prod"
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-32436"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "fed@groupon.com"
  tenantservice_tag = "accounting_service"
}
