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
  instance_type       = "db.r6g.large"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "my_noncore_us_501_stg"
  cname = "my-noncore-us-501-stg"
  engine			  = "aurora-mysql"
  # engine_version          = "5.7.mysql_aurora.2.07.1"
  # engine_version          = "5.7.mysql_aurora.2.10.1"
  engine_version            = "5.7.mysql_aurora.2.11.2"
  # apply_immediately = true
  multi_az			  = false
  port				  = 3306
  allocated_storage = ""
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  performance_insights_enabled = true
  jira_tag           = "GDS-25129:GDS-24585-afl-3pgw-stg:GDS-24019-developer-portal-stg:GDS-24762-gso-merchant-success:GDS-24629-app_sts_dsbrd_stg"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag     = "gds@groupon.com"
  tenantservice_tag  = "multi-tenant"
}
