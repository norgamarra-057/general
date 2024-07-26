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
  instance_type       = "db.r6g.xlarge"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "debug"
  engine_version          = "14.7"
  multi_az                        = false
  apply-immediately = true
  port				  = 5432
  db_name			  = "marketing_deal_service_prod"
  apply_immediately = "true"
  max_allocated_storage = 6000
  allocated_storage = 5000
  replicate_source_db = ""
  cname = "marketing-deal-service-prod"
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-34701"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "mis-engineering@groupon.com"
  tenantservice_tag = "marketing-deal-service"
}
