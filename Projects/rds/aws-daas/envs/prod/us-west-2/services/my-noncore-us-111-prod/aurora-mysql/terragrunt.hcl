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
  instance_type       		= "db.r6g.large"
  local_replica_cnt 		= 1
  local_subnet_group  		= "sgroup-1"
  size                		= "small"
  db_name			= "my_noncore_us_111_prod"
  cname				= "my-noncore-us-111-prod"
  engine			= "aurora-mysql"
  engine_version	  	= "8.0.mysql_aurora.3.01.1"
  multi_az			= true
  port				= 3306
  cluster_master_arn  		= ""
  backup_retention_period = 15
  performance_insights_enabled 	= true
  storage_encrypted 		= true
  kms_key_id			= "arn:aws:kms:us-west-2:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  account_id 			= get_aws_account_id()
  jira_tag 			= "GDS-35157"
  service_tag        		= "daas_mysql"
  owner_tag          		= "gds@groupon.com"
  tenantteam_tag 		= "gds@groupon.com"
  tenantservice_tag 		= "multi-tenant"
}
