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
  instance_type       = "db.r6g.2xlarge"
  local_replica_cnt = 2
  local_subnet_group  = "sgroup-1"
  size                = "small"
  db_name			  = "voucherinventory_prod"
  cname			= "vis-emea-copy-prod"
  engine			  = "aurora-mysql"
  engine_version	  = "5.7.mysql_aurora.2.10.1"
  multi_az			  = false
  port				  = 3306
  storage_encrypted = false
  performance_insights_enabled = true
#  final_snapshot_identifier = "voucherinventory_prod_final_snapshot"
#  skip_final_snapshot = false
  account_id = get_aws_account_id()
#  source_region = "us-west-1"
  cluster_master_arn  = "arn:aws:rds:us-west-1:497256801702:cluster:vis-copy-prod"
  jira_tag = "GDS-19966"
  service_tag        = "daas_mysql"
  owner_tag          = "gds@groupon.com"
  tenantteam_tag = "voucher-inventory-dev@groupon.com"
  tenantservice_tag = "voucher-inventory"
}
