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
  instance_type       		= "db.t4g.large"
  local_replica_cnt 		= 0
  apply_immediately   = true
  local_subnet_group  		= "sgroup-1"
  size                		= "small"
  db_name			= "my_noncore_gl_441_prod_emea"
  cname 			= "my-noncore-gl-441-prod-emea"
  engine			= "aurora-mysql"
  engine_version	  	= "5.7.mysql_aurora.2.11.2"
  multi_az			= true
  port				= 3306
  account_id 			= get_aws_account_id()
  cluster_master_arn  		= "arn:aws:rds:us-west-1:497256801702:cluster:my-noncore-gl-441-prod"
  jira_tag 			= "GDS-33364"
  service_tag        		= "daas_mysql"
  owner_tag          		= "gds@groupon.com"
  tenantteam_tag 		= "gds@groupon.com"
  tenantservice_tag 		= "multi-tenant"
  performance_insights_enabled 	= true
}
