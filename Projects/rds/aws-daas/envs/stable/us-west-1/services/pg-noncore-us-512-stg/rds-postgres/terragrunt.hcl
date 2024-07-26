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
  size                = "debug"
  db_name			  = "pg_noncore_us_512_stg"
  engine			  = "postgres"
  engine_version	  = "14.7"
  multi_az			  = false
  port				  = 5432
  cluster_master_arn  = ""
  cname = "pg-noncore-us-512-stg"
  storage_type ="gp3"
  iops = 12000
  max_allocated_storage = 6000
  allocated_storage = 500
  performance_insights_enabled = true
  storage_encrypted = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-25130:GDS-24532-optimus-prime-stg:GDS-24736-mols-stg"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"
  apply_immediately = "true"

}
