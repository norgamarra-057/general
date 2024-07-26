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
  local_replica_cnt = 0
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pg_core_us_531_stg"
  engine			  = "postgres"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  apply_immediately = true
  cluster_master_arn  = ""
  max_allocated_storage = 2000
         storage_type                          = "gp3"
  iops=12000
  storage_encrypted = false
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  allocated_storage = 500
  account_id  = get_aws_account_id()
  backup_retention_period = 7
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-28369"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
