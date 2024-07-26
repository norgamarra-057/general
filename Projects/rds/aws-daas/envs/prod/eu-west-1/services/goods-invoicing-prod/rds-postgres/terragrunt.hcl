terraform {
    source = "../../../../../../modules/rds-postgres"
}

include {
	path = find_in_parent_folders()
}

dependencies {
	paths = [
  		"../../../database/networking",
#     	"../../../database/options",
  		"../../../database/parameters/rds/11",
  		"../../../database/security",
	]
}


# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r5.large"
  local_replica_cnt   = "1"
  local_subnet_group  = "sgroup-1"
  size                = "medium"
  db_name       = "goods_invoicing_prod"
  cname = "goods-invoicing-prod"
  engine_version          = "11.19"
  multi_az			  = false
  apply_immediately = true 
  port				  = 5432
  allocated_storage = 100
  max_allocated_storage = 200
  account_id = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  cluster_master_arn  = ""
  performance_insights_enabled    = true
  jira_tag = "GDS-32458"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "goods-eng-seattle@groupon.com"
  tenantservice_tag = "goods_invoice_aggregator"
}
