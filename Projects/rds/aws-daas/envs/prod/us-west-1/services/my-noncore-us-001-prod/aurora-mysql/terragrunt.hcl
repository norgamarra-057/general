terraform {
    source = "../../../../../../modules/aurora-mysql"
}

include {
	path = find_in_parent_folders()
}

dependencies {
	paths = [
  		"../../../database/networking",
#     	"../../../database/options",
  		"../../../database/parameters/aurora/5.7",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.t4g.large" 
  local_replica_cnt = 0
  backup_retention_period = 15
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "my_noncore_us_001_prod"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = true
  port				  = 3306
  apply_immediately = true
  performance_insights_enabled = true
  cluster_master_arn  = ""
  account_id  = get_aws_account_id()
  cname = "my-noncore-us-001-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-25137:GDS-24020-developer-portal-prod:GDS-24583-afl-3pgw-prod:GDS-23311-cloud-migration-tracker-prod:GDS-23439-srs-job-scheduler-prod"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"
}
