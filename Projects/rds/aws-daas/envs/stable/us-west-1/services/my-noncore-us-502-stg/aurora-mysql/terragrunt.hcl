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
  instance_type       = "db.r6g.4xlarge"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "my_noncore_us_502_stg"
  cname = "my-noncore-us-502-stg"
  engine			  = "aurora-mysql"
  # engine_version    = "5.7.mysql_aurora.2.07.1"
  # engine_version    = "5.7.mysql_aurora.2.10.1"
  engine_version      = "5.7.mysql_aurora.2.11.2"
  apply_immediately   = true
  multi_az			  = false
  port				  = 3306
  allocated_storage = ""
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  performance_insights_enabled = true
  storage_encryption_enabled = true
  jira_tag           = "GDS-28447"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag     = "gds@groupon.com"
  tenantservice_tag  = "multi-tenant"
}