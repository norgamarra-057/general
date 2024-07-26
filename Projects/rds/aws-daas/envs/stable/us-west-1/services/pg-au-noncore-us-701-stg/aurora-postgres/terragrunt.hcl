terraform {
    source = "../../../../../../modules/aurora-postgres"
}

include {
	path = find_in_parent_folders()
}

dependencies {
	paths = [
  		"../../../database/networking",
#     	"../../../database/options",
  		"../../../database/parameters/aurora/pg13",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r6g.large"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pg_au_noncore_us_701_stg"
  engine			  = "aurora-postgresql"
  engine_version	  = "13.9"
  multi_az			  = true
  port				  = 5432
  backup_retention_period = 7
  cluster_master_arn  = ""
  cname = "pg-au-noncore-us-701-stg"
  performance_insights_enabled = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-33705"
  service_tag        = "daas_postgres"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
