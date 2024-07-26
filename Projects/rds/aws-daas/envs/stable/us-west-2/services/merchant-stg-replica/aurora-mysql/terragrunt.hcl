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
  instance_type       = "db.t2.small"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = ""
  engine			  = "aurora-mysql"
  #engine_version	  = "5.7.mysql_aurora.2.07.1"
  #engine_version	  = "5.7.mysql_aurora.2.10.1"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  multi_az			  = true
  port				  = 3306
  account_id  = get_aws_account_id()
  # this causes TF to drop existing cluster and create a new replica one
  # cluster_master_arn  = "arn:aws:rds:us-west-1:286052569778:cluster:merchant-stg"
  # this causes TF to keep existing cluster
  cluster_master_arn  = ""
  # this causes TF to drop existing cluster and create a new replica one
  #cluster_master_arn  = "arn:aws:rds:us-west-2:286052569778:cluster:merchant-stg-replica"
  performance_insights_enabled = false
  jira_tag = "GDS-19948"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "merchantdata@groupon.com"
  tenantservice_tag = "m3_merchant_service"
}
