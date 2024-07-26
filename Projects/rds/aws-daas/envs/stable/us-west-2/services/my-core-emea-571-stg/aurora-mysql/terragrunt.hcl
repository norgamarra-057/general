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
  db_name			  = "my_core_emea_571_stg"
  engine			  = "aurora-mysql"
  # engine_version	  = "5.7.mysql_aurora.2.07.1"
  # engine_version	  = "5.7.mysql_aurora.2.10.1"
  engine_version          = "5.7.mysql_aurora.2.12.2"
  performance_insights_enabled = false
  multi_az			  = true
  port				  = 3306
  allocated_storage = ""
  cname = "my-core-emea-571-stg"
  apply_immediately = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = ""
  jira_tag = "GDS-25133"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
