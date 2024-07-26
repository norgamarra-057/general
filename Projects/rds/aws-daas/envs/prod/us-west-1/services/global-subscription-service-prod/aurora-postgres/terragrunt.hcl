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
  		"../../../database/parameters/aurora/pg14",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r6g.4xlarge"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "global_subscription_service_prod"
  engine			  = "aurora-postgresql"
  engine_version	  = "14.3"
  multi_az			  = true
  port				  = 5432
  cluster_master_arn  = ""
  cname = "global-subscription-service-prod"
  kms_key_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  apply_immediately = true 
  storage_encrypted  = true
  performance_insights_enabled = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-35078"
  service_tag        = "daas_postgres"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "subscriptions-engineering@groupon.com"
  tenantservice_tag = "global_subscription_service"


}
