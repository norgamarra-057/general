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
  instance_type       = "db.t3.small"
  local_replica_cnt = 2
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pablob"
  cname       = "pablob--pg.dev"
  engine			  = "postgres"
  engine_version	  = "11.15"
  multi_az			  = true
  port				  = 5432
  enhanced_monitoring = false
  cluster_master_arn  = ""
  max_allocated_storage = 1000
  allocated_storage = 500
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-33898"
  service_tag = "daas_postgres"
  owner_tag = "pablo@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"
}
