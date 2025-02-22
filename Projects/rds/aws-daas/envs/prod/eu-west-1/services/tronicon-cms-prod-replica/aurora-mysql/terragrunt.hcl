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
  local_replica_cnt = 0
  local_subnet_group  = "sgroup-1"
  size                = "small"
#  db_name			  = "tronicon_cms_prod"
  db_name			  = "ranger_prod"
  cname 		= "tronicon-cms-prod-replica"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = true
  port				  = 3306
  performance_insights_enabled = true
  storage_encrypted = true
  account_id = get_aws_account_id()
  # source_region = "us-west-1"
  storage_encrypted = true
  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:tronicon-cms-prod"
  jira_tag = "GDS-30244"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "tronicon-dev@groupon.com"
  tenantservice_tag = "tronicon_service"
}
