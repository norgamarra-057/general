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
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  db_name			  = "deal_perf_v2_prod_new"
  replicate_source_db = ""
  apply_immediately = true
  max_allocated_storage = 3000
  allocated_storage = 2000
  storage_type     = "gp3"
  iops             = "20000"
  account_id  = get_aws_account_id()
  cname = "deal-perf-v2-new-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-37265"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "core-ranking-team@groupon.com"
  tenantservice_tag = "deal-performance-service-v2"
}
