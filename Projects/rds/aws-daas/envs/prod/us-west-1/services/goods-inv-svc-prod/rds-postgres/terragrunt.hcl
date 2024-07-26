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
  size                = "debug"
  engine_version          = "11.19"
  multi_az			  = false
  port				  = 5432
  db_name			  = "goods_inv_svc_prod"
  apply_immediately = true
  replicate_source_db = ""
  storage_type     = "io1"
  iops             = "10000"
  max_allocated_storage = 3000
  allocated_storage = 2000
  account_id  = get_aws_account_id()
  cname = "goods-inv-svc-prod"
  maintenance_window  = "mon:00:00-mon:03:00"
  kms_id = "arn:aws:kms:us-west-1:497256801702:key/mrk-20435c510ff141608437364b96e1ca20"
  storage_encrypted  = true
  jira_tag = "GDS-32505"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "goods-eng-seattle@groupon.com"
  tenantservice_tag = "goods-inventory-service"
}
