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
  instance_type       	= "db.r6g.2xlarge"
  local_replica_cnt 	= 1
  local_subnet_group  	= "sgroup-1"
  size                	= "small"
  db_name		= "gtwy_travel_inv"
  cname 		= "gtwy-travel-inv-prod"
  engine		= "aurora-mysql"
  engine_version	= "5.7.mysql_aurora.2.10.1"
  multi_az		= false
  port			= 3306
  storage_encrypted     = true
  kms_key_id 		= "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  cluster_master_arn  	= ""
  performance_insights_enabled = true
  account_id  		= get_aws_account_id()
  maintenance_window  	= "mon:00:00-mon:03:00"
  jira_tag 		= "GDS-32459"
  service_tag        	= "daas_mysql"
  owner_tag          	= "gds@groupon.com"
  tenantteam_tag 	= "getaways-eng@groupon.com"
  tenantservice_tag 	= "getaways-inventory"
  apply_immediately   	= true


}
