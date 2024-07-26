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
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version          = "11.19"
  multi_az                        = false
  apply-immediately = true
  port				  = 5432
  db_name			  = "mls_deal_index_prod"
  replicate_source_db = ""
  apply_immediately = true
  max_allocated_storage = 4000
  allocated_storage = 999
  account_id  = get_aws_account_id()
  cname = "mls-deal-index-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-30272"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "bmx@groupon.com"
  tenantservice_tag = "mls-sentinel"
}
