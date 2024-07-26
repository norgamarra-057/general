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
  instance_type       = "db.r5.large"
  local_replica_cnt   = "0"
  backup_retention_period = 35
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine_version          = "11.19"
  multi_az			  = false
  port				  = 5432
  db_name			  = "goods_market_pricing_prod"
  replicate_source_db = ""
  apply_immediately = true
  max_allocated_storage = 3000
  allocated_storage = 2000
  storage_encrypted  = true
  cname = "goods-market-pricing-prod"
  kms_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-34228"
  service_tag = "daas_postgres"
  owner_tag = "GDS"
  tenantteam_tag = "goods-eng-seattle@groupon.com"
  tenantservice_tag = "goods-market-pricing"
}
