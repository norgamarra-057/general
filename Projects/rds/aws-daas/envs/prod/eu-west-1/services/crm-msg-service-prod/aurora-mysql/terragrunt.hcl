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
  instance_type       		= "db.r6g.xlarge"
  local_replica_cnt 		= 1
  local_subnet_group  		= "sgroup-1"
  size                		= "large"
  db_name			= "crm_message_service"
  cname				= "crm-msg-service-prod"
  engine			= "aurora-mysql"
  engine_version	   	= "5.7.mysql_aurora.2.11.2"
  multi_az			= true 
  port				= 3306
  account_id 			= get_aws_account_id()
  performance_insights_enabled 	= true
  cluster_master_arn 		= ""  
  storage_encrypted  		= true
  jira_tag           		= "GDS-29623"
  service_tag        		= "daas_mysql"
  owner_tag          		= "gds@groupon.com"
  tenantteam_tag     		= "is-ms-engg@groupon.com"
  tenantservice_tag  		= "crm-message-service"
  apply_immediately   = true
}
