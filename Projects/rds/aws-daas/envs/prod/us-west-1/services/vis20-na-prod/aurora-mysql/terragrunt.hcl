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
  #instance_type       = "db.r5.2xlarge"
  instance_type       = "db.r6g.4xlarge"
  local_replica_cnt   = 2
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "vis20_na_prod"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.10.1"
  multi_az			  = true
  port				  = 3306
  cluster_master_arn  = ""
  account_id = get_aws_account_id()
  backup_retention_period=35
  jira_tag = "GDS-19956"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "voucher-inventory-dev@groupon.com"
  tenantservice_tag = "voucher-inventory"
  performance_insights_enabled = true
}
