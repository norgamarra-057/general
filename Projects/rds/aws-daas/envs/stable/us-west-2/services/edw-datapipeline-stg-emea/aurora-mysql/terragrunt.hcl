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
  apply_immediately   = true
  local_replica_cnt = 0
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "edw_datapipeline_stg_emea_db"
  engine			  = "aurora-mysql"
  # engine_version	  = "5.7.mysql_aurora.2.10.1"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  performance_insights_enabled = false
  multi_az			  = false
  port				  = 3306
  allocated_storage = ""
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-25133"
  service_tag        = "grpn-data-pipelines"
  owner_tag          = "data-engineering"
  tenantteam_tag = "data-engineering@groupon.com"
  tenantservice_tag = "data-engineering"

}
