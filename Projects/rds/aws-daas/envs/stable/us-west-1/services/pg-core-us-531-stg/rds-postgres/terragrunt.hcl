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
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pg_core_us_531_stg"
  engine			  = "postgres"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  cluster_master_arn  = ""
  cname = "pg-core-us-531-stg"
  max_allocated_storage = 6800
  performance_insights_enabled = true
  apply_immediately = true 
  allocated_storage = 500
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-25130:GDS-24532-optimus-prime-stg:GDS-24736-mols-stg"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
