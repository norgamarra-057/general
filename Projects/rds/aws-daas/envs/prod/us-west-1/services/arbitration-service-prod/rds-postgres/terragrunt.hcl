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
  		"../../../database/parameters/rds/14",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r5.4xlarge"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version	  = "14"
  apply_immediately   = true
  multi_az			  = false
  port				  = 5432
  db_name			  = "arbitration_prod"
  storage_type     = "io1"
  iops             = "20000"
  replicate_source_db = ""
  max_allocated_storage = 5000
  allocated_storage = 1500
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-32911"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "cas-dev@groupon.com"
  tenantservice_tag = "arbitration-service"
}
