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
  engine_version	  = "11.15"
  multi_az                        = false
  apply-immediately = true
  port				  = 5432
  db_name			  = "merchant_access_prod"
  replicate_source_db = ""
  max_allocated_storage = 1000
  allocated_storage = 500
  cname = "merchant-access-prod"
  kms_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-32381"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "merchant-experience-backend@groupon.com"
  tenantservice_tag = "mx-merchant-access"
}
