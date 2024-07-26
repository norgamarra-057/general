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
  instance_type       	= "db.t4g.large"
  local_replica_cnt 	= 0
  local_subnet_group  	= "sgroup-1"
  size                	= "small"
  db_name		= "janus_prod"
  cname = "janus-prod-emea"
  engine		= "aurora-mysql"
  engine_version	= "5.7.mysql_aurora.2.11.2"
  multi_az		= true
  port			= 3306
  cluster_master_arn  	= "arn:aws:rds:us-west-1:497256801702:cluster:janus-prod"
  performance_insights_enabled = true
  apply_immediately   = true
  storage_encrypted     = true
  kms_key_id = "arn:aws:kms:eu-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  account_id 		= get_aws_account_id()
  jira_tag 		= "GDS-34238"
  service_tag        	= "daas_mysql"
  owner_tag          	= "gds@groupon.com"
  tenantteam_tag 	= "data-curation-platform@groupon.com"
  tenantservice_tag 	= "janus"
}
