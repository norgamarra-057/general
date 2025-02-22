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
  instance_type       = "db.t4g.large"
  local_replica_cnt = 0
  apply_immediately   = true
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "online_booking_availability_engine"
  cname = "ol-book-avail-prod"
  engine			  = "aurora-mysql"
  #engine_version	  = "5.7.mysql_aurora.2.04.6"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = true 
  port				  = 3306
  account_id = get_aws_account_id()
  performance_insights_enabled = true
  cluster_master_arn  = ""  
  storage_encrypted  = true
  jira_tag           = "GDS-29759"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag     = "onlinebooking-devteam@groupon.com"
  tenantservice_tag  = "calendar-service"
}
