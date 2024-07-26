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
  local_replica_cnt   = "0"
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name       = "mailman_lup1_prod"
  cname         = "mailman-lup1-prod"
  engine_version	  = "11.19"
  multi_az			  = false 
  port				  = 5432
  apply_immediately = true
  allocated_storage = 1000
  storage_encrypted  = true
  kms_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  max_allocated_storage = 2000
  account_id = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  cluster_master_arn  = ""
  performance_insights_enabled    = true
  jira_tag = "GDS-32572"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "rocketman-india-team@groupon.com"
  tenantservice_tag = "mailman"



}
