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
  instance_type                = "db.r6g.large"
  local_replica_cnt            = "0"
  local_subnet_group           = "sgroup-1"
  size                         = "small"
  db_name                      = "mysql_demo"
#  cname                        = "dminor8"
  engine                       = "aurora-mysql"
  engine_version               = "8.0.mysql_aurora.3.01.1"
  cluster_master_arn           = ""
  multi_az                     = false 
  port                         = 3306
  allocated_storage            = ""
  apply_immediately            = "true"
  account_id                   = get_aws_account_id()
  maintenance_window           = "mon:00:00-mon:03:00"
  performance_insights_enabled = false
  jira_tag                     = "GDS-XXXXX"
  service_tag                  = "daas_mysql"
  service_portal_tag           = "daas_mysql"
  owner_tag                    = "dminor@groupon.com"
  tenantteam_tag               = "gds@groupon.com"
  tenantservice_tag            = "daas_mysql"
}
