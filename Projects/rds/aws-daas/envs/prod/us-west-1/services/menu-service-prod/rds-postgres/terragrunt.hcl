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
  instance_type       = "db.t3.large"
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "small"
  engine_version	  = "11.19"
  multi_az                        = false
  apply-immediately = true
  port				  = 5432
  db_name			  = "menu_service_prod"
  max_allocated_storage = 1000
  allocated_storage = 500
  replicate_source_db = ""
  account_id  = get_aws_account_id()
  cname = "menu-service-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-33533"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "merchantdata@groupon.com"
  tenantservice_tag = "menu-service-v2"
}
