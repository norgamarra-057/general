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
  instance_type       = "db.t4g.medium"
  apply_immediately   = true
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "client_id_stg"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  cname			= "client-id-stg-replica"
  multi_az			  = false
  backup_retention_period = 7
  port				  = 3306
  allocated_storage = ""
  performance_insights_enabled = false 
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  cluster_master_arn  = "arn:aws:rds:us-west-1:286052569778:cluster:client-id-stg"
  # cluster_master_arn  = ""
  jira_tag           = "GDS-19988"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag     = "apidevs@groupon.com"
  tenantservice_tag  = "client-id"
  skip_final_snapshot = true
}
