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
  instance_type       = "db.r5.2xlarge"
  local_replica_cnt = 1
  local_subnet_group  = "sgroup-1"
  size                = "large"
  db_name			  = "pg_noncore_us_514_stg"
  engine			  = "postgres"
  # engine_version	  = "11.15"
  engine_version          = "14.7"
  multi_az			  = false
  port				  = 5432
  storage_encrypted  = true
  storage_type ="gp2"
  cluster_master_arn  = ""
  cname = "pg-noncore-us-515-stg"
  max_allocated_storage = 6000
  allocated_storage = 4000
#  storage_type     = "io1"
#  iops             = "10000"
  performance_insights_enabled = true
  storage_encrypted = true
  account_id  = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00" 
  # kms_key_id = "arn:aws:kms:us-west-1:286052569778:key/mrk-e2f2bd1b795141d0970993ca0a6d0ca6"
  kms_key_id = "arn:aws:kms:us-west-1:286052569778:key/73d12383-dc38-4e43-a7be-dabf83968361"  
  cluster_master_arn  = ""
  jira_tag = "GDS-25130"
  service_tag = "daas_postgres"
  owner_tag = "gds@groupon.com"
  tenantteam_tag = "gds@groupon.com"
  tenantservice_tag = "multi-tenant"

}
