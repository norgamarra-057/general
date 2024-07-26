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
  instance_type       = "db.r5.xlarge"
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "small"
  engine_version          = "11.19"
  apply_immediately   = true
  multi_az			  = false 
  port				  = 5432
  db_name			  = "gdc_prod"
  cname = "gdc-prod"
  max_allocated_storage = 1000
  allocated_storage = 500
  kms_id = "arn:aws:kms:eu-west-1:497256801702:key/8b4310fe-e786-468a-aa89-244cb725ade7"
  storage_encrypted  = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-33037"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "goods-blr@groupon.com"
  tenantservice_tag = "deal_centre"
}
