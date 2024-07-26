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
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine_version          = "11.19"
  multi_az			  = false
  apply_immediately = true
  port				  = 5432
  db_name			  = "partner_attr_map_prod"
  replicate_source_db = ""
  max_allocated_storage = 1000
  allocated_storage = 50
  account_id  = get_aws_account_id()
  cname = "partner-attr-map-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  performance_insights_enabled=true
  jira_tag = "GDS-28261"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "clo-dev@groupon.com"
  tenantservice_tag = "partner-attributes-mapping-service"

}
