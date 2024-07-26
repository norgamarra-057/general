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
  db_name			  = "killbill_production"
  cname = "killbill-prod"
  engine			  = "aurora-mysql"
  apply_immediately = true
  # engine_version	  = "5.7.mysql_aurora.2.11.2"
  engine_version        = "5.7.mysql_aurora.2.12.2"
  multi_az			  = true 
  port				  = 3306
  cname               = "killbill-prod"
  account_id = get_aws_account_id()
  performance_insights_enabled = true
  cluster_master_arn  = ""  
  storage_encrypted  = true
  kms_key_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  jira_tag           = "GDS-30234"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag     = "cap-payments@groupon.com"
  tenantservice_tag  = "killbill-payments"
}
