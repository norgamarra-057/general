terraform {
    source = "../../../../../../modules/aurora-postgres"
}

include {
	path = find_in_parent_folders()
}

dependencies {
	paths = [
  		"../../../database/networking",
#     	"../../../database/options",
  		"../../../database/parameters/aurora/pg13",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.t4g.medium"
  local_replica_cnt = 2
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pablo_aurora_pg"
  cname       = "pablo-aurora-pg.dev"
  engine			  = "aurora-postgresql"
  engine_version	  = "13.3"
  multi_az			  = true
  port				  = 5432
  cluster_master_arn  = ""
  performance_insights_enabled = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag = "GDS-33898"
  service_tag        = "daas_postgres"
  owner_tag          = "pablo@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "daas_postgres"

}
