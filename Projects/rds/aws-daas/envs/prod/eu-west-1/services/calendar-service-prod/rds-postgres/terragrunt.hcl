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
  db_name       = "calendar_service_prod"
  cname = "calendar-service-prod"
  engine_version          = "11.19"
  multi_az			  = false
  apply_immediately  = true 
  port				  = 5432
  allocated_storage = 500
  max_allocated_storage = 1000
  account_id = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  cluster_master_arn  = ""
  skip_final_snapshot                    = "true"
  jira_tag = "GDS-30652"
  service_tag = "daas_postgres"
  owner_tag = "3pip-custom-integrationseng@groupon.com"
  tenantteam_tag = "3pip-Custom-Integrations-TCI"
  tenantservice_tag = "calendar-service"


#  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:customfieldsapp-prod"
#  arn  = "arn:aws:rds:us-west-1:497256801702:db:customfieldsapp-prod"
}
