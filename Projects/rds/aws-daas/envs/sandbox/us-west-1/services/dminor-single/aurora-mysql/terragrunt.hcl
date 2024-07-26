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
                "../../../databases/backups",
  		"../../../database/parameters/aurora/5.7",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type                = "db.r5.large"
  local_replica_cnt            = "0"
  local_subnet_group           = "sgroup-1"
  size                         = "small"
  db_name                      = "mysql_demo"
  engine                       = "aurora-mysql"
  engine_version               = "8.0.mysql_aurora.3.01.0"
  cluster_master_arn           = ""
  multi_az                     = false 
  port                         = 3306
  allocated_storage            = ""
  account_id                   = get_aws_account_id()
  maintenance_window           = "mon:00:00-mon:03:00"
  performance_insights_enabled = true
  storage_encrypted            = true
  kms_id                       = "arn:aws:kms:us-west-1:497256801702:key/19854482-f528-4825-a8d2-9b4d7f501ae6"
  jira_tag                     = "GDS-XXXXX"
  service_tag                  = "daas_mysql"
  service_portal_tag           = "daas_mysql"
  owner_tag                    = "dminor@groupon.com"
  tenantteam_tag               = "gds@groupon.com"
  tenantservice_tag            = "daas_mysql"
}
