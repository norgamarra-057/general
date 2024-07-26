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
  # instance_type       = "db.t2.small"
  instance_type       = "db.t3.small"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  # cluster_identifier = "rapt-emea-stg"
  # db_name = "rapt-emea-stg"
  # db_name			  = "deploybot_db"
  db_name			  = "rapt_db_stg"
  engine			  = "aurora-mysql"
  # engine_version	  = "5.7.mysql_aurora.2.07.1"
  engine_version	  = "5.7.mysql_aurora.2.10.1"
  multi_az			  = true
  port				  = 3306
  account_id  = get_aws_account_id()
  allocated_storage = ""
  maintenance_window  = "mon:00:00-mon:03:00"
  # cluster_master_arn  = "arn:aws:rds:us-west-2:286052569778:cluster:rapt-emea-stg"
  cluster_master_arn = ""
  performance_insights_enabled = false
  #jira_tag = "GDS-302438"
  jira_tag = "GDS-30243"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "rapt@groupon.com"
  #tenantservice_tag = "deploybote"
  tenantservice_tag = "deploybot"
}
