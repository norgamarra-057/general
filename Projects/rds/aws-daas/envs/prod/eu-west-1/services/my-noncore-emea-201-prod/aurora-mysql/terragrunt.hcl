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
  instance_type       = "db.r6g.large"
  local_replica_cnt = 0
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "my_noncore_emea_201_prod"
  cname = "my-noncore-emea-201-prod"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = true
  port				  = 3306
  account_id = get_aws_account_id()
  cluster_master_arn  = ""
  jira_tag = "GDS-25141:GDS-24600-gso-merchant-success-emea-qa:GDS-24377-gso-merchant-success-emea-prod:GDS-24584-afl_3pgw_production"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"
  performance_insights_enabled = true
}
