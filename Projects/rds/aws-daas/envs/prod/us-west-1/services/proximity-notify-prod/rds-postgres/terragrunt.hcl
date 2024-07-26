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
  size                = "large"
  engine_version          = "11.19"
  multi_az			  = false
  apply_immediately = true
  port				  = 5432
  db_name			  = "proximity_notify_prod"
  replicate_source_db = ""
  max_allocated_storage = 4000
  allocated_storage = 1000
  performance_insights_enabled = true
  account_id  = get_aws_account_id()
  cname = "proximity-notify-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-31969"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "emerging-channels@groupon.com"
  tenantservice_tag = "proximity_notifications"

}
