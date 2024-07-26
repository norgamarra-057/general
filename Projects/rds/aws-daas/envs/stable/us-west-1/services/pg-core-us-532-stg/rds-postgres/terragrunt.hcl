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
  size                = "debug"
  db_name			  = "pg_core_us_532_stg"
  engine			  = "postgres"
  engine_version	  = "14.11"
  multi_az			  = false
  port				  = 5432
  az = "us-west-1c"
  cluster_master_arn  = ""
  apply_immediately = true
  iops = 12000
  backup_retention_period = 7
  cname = "pg-core-us-532-stg"
  max_allocated_storage = 2200
  performance_insights_enabled = true
  allocated_storage = 1500
  storage_type= "gp3"
  storage_encrypted = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-28592"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
