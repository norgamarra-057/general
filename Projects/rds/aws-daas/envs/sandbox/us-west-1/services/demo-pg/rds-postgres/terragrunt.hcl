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
  		"../../../database/parameters/rds/10",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.t2.small"
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  engine              = "postgres"
  engine_version      = "10"
  multi_az            = false
  port                = 5432
  db_name             = "demopg"
#  account_id          = get_aws_account_id()
  replicate_source_db = ""
  jira_tag            = "GDS-XXXXX"
  service_tag         = "daas_postgres"
  owner_tag           = "dminor@groupon.com"
  tenantteam_tag      = "gds@groupon.com"
  tenantservice_tag   = "multi-tenant"
}
