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
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "medium"
  engine_version	  = "11.15"
  multi_az			  = false
  port				  = 5432
  replicate_source_db = ""
  allocated_storage = 100
  max_allocated_storage = 200
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  db_name             = "pg_klarsen"
  jira_tag            = "GDS-XXXXX"
  service_tag         = "daas_mysql"
  service_portal_tag  = "daas_mysql"
  owner_tag           = "klarsen@groupon.com"
  tenantteam_tag      = "gds@groupon.com"
  tenantservice_tag   = "daas_postgres"
}
