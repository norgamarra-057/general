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
  instance_type       = "db.r6g.large"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pg_core_us_533_stg"
  engine			  = "postgres"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  cluster_master_arn  = ""
  apply_immediately = true
  max_allocated_storage = 2000
  cname = "pg-core-us-533-stg"
  performance_insights_enabled = true
  allocated_storage = 1100
#  storage_type     = "io1"
#  iops             = "10000"
  storage_encrypted = true
  account_id  = get_aws_account_id()
#  kms_key_id = "arn:aws:kms:us-west-1:286052569778:key/mrk-e2f2bd1b795141d0970993ca0a6d0ca6"
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-28592"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
