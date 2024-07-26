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
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "travel_content_production"
  cname = "getaways-content-prod-replica"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = true
  port				  = 3306
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  storage_encrypted = true
  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:getaways-content-prod"
  jira_tag = "GDS-31742"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "getaways-eng@groupon.com"
  tenantservice_tag = "getaways-content"

}
