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
  instance_type                = "db.t4g.large"
  local_replica_cnt            = 0
  local_subnet_group           = "sgroup-1"
  size                         = "small"
  db_name                      = "cmi_travelclick_prod"
  cname			       = "cmi-travelclick-prod"
  engine                       = "aurora-mysql"
  multi_az                     = true
  engine_version               = "5.7.mysql_aurora.2.11.2"
  port                         = 3306
  apply_immediately            = true
  cluster_master_arn           = ""
  performance_insights_enabled = true
  storage_encrypted            = true
  backup_retention_period = 35
  account_id                   = get_aws_account_id()
  jira_tag                     = "GDS-29366"
  service_tag                  = "daas_mysql"
  owner_tag                    = "gds@groupon.com"
  tenantteam_tag               = "getaways-supply-dev@groupon.com"
  tenantservice_tag            = "channel-manager-integrator-travelclick"
}
