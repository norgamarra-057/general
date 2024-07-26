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
  backup_retention_period = 35
  local_subnet_group  = "sgroup-1"
  size                = "small"
  apply_immediately   = true
  db_name			  = "my_core_us_102_prod"
  cname			=	"my-core-us-102-prod"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.11.2"
  multi_az			  = false
  port				  = 3306
  cluster_master_arn  = ""
  account_id  = get_aws_account_id()
  performance_insights_enabled = true
  storage_encrypted            = true
  kms_key_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-34230"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"
}
