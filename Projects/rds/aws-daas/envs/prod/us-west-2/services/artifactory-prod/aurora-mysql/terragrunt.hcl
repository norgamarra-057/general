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
  instance_type       = "db.r6g.xlarge"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "artdb"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.10.1"
  multi_az			  = true
  port				  = 3306
  apply_immediately               = true
  cluster_master_arn  = ""
#  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:artifactory-prod"
  performance_insights_enabled = true
  storage_encrypted = true
  account_id = get_aws_account_id()
  jira_tag = "GDS-28408"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "scam-team@groupon.com"
  tenantservice_tag = "artifactory"
}
