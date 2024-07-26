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
  db_name       = "goods_deletion_prod"
  engine_version          = "11.19"
  cname = "goods-deletion-prod"
  multi_az			  = false
  apply_immediately = true 
  port				  = 5432
  allocated_storage = 1000
  max_allocated_storage = 2000
  account_id = get_aws_account_id()
  replicate_source_db = ""
  storage_type     = "gp2"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled    = true
  apply_immediately = "true"
  jira_tag = "GDS-31966"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "goods-cxx-dev@groupon.com"
  tenantservice_tag = "deletion_service"
}
