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
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "goods_shipment_db_staging"
  engine			  = "aurora-mysql"
  # engine_version	  = "5.7.mysql_aurora.2.09.2"
  # engine_version	  = "5.7.mysql_aurora.2.10.1"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  apply_immediately  = true
  multi_az			  = false
  port				  = 3306
  allocated_storage = ""
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag           = "GDS-30083"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag     = "goods_outbound_post_dev@groupon.com"
  tenantservice_tag  = "shipment-tracker-frontend"
}
