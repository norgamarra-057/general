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
  instance_type       = "db.r6g.2xlarge"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "groupon_production"
  cname 	= "orders-prod"
  engine			  = "aurora-mysql"
  #engine_version          = "5.7.mysql_aurora.2.11.2"	
  engine_version           = "5.7.mysql_aurora.2.12.2"
  multi_az			  = true
  port				  = 3306
  apply_immediately = true
  cluster_master_arn  = ""
  performance_insights_enabled = true
  storage_encrypted = true
  kms_id: "arn:aws:kms:us-west-1:497256801702:key/19854482-f528-4825-a8d2-9b4d7f501ae6"
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-32687"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "orders-eng@groupon.com"
  tenantservice_tag = "orders"


}
