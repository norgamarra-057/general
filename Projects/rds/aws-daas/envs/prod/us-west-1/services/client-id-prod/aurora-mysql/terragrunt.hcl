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
  size                = "large"
  cname		=	"client-id-prod"
  db_name			  = "client_id_prod"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = false
  port				  = 3306
  backup_retention_period=35
  cluster_master_arn  = ""
  account_id  = get_aws_account_id()
  jira_tag = "GDS-19998"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "apidevs@groupon.com"
  tenantservice_tag = "client-id"

}
