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
  local_replica_cnt   = "2"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine_version          = "11.19"
  allocated_storage = 1000
  max_allocated_storage   = 2000
  storage_type     = "io1"
  iops             = "1000"
  multi_az			  = false 
  port				  = 5432
  db_name			  = "bhuvan_prod"
  performance_insights_enabled    = true
  replicate_source_db = "arn:aws:rds:us-west-1:497256801702:db:bhuvan-prod"
  account_id = get_aws_account_id()
  jira_tag = "GDS-30259"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "geo-team@groupon.com"
  tenantservice_tag = "bhuvan"

#  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:bhuvan-prod"
#  arn  = "arn:aws:rds:us-west-1:497256801702:db:bhuvan-prod"
}
