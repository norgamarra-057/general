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
  instance_type       = "db.r5.xlarge"
  local_replica_cnt   = "3"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version	  = "11.19"
  multi_az			  = false
  port				  = 5432
  db_name			  = "goodscentral_db"
  replicate_source_db = ""
  max_allocated_storage = 3000
  allocated_storage = 2000
  account_id  = get_aws_account_id()
  apply_immediately = "true"
  kms_key_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  cname = "goodscentraldb-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  storage_encrypted = true
  performance_insights_enabled=true
  jira_tag = "GDS-32382"
  service_tag = "daas_postgres"
  owner_tag = "GDS"
  tenantteam_tag = "goods-eng-seattle@groupon.com "
  tenantservice_tag = "goods_commerce_interface"
}
