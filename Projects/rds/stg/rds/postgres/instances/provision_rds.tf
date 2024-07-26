## Persist terraform state in S3. Also, use a DynamoDB table to handle locking.

terraform {
  required_version = ">=0.11.9"
  backend "s3" {
    bucket         = "gds-rds-terraform-state"
    key            = "pg-instances-states"
    region         = "us-west-1"
    dynamodb_table = "daas-terraform-lock-table"
  }
}

## The following 'locals' block is basically checking on which workspace we are, and making mapping chained variables. Note that we have defined the necessary maps in variables.tf 

locals {
  environment        = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  instance_type      = "${lookup(var.environment_to_insttype_map, local.environment, "dev")}"
  size               = "${var.environment_to_size_map[local.environment]}"
  dbname             = "${lookup(var.environment_to_dbname_map, local.environment, "testdb")}"
  primary_region     = "${lookup(var.environment_to_primary_region_map, local.environment, "none")}"
  remote_region      = "${lookup(var.environment_to_remote_region_map, local.environment, "none")}"
  remote_replica      = "${lookup(var.environment_to_remote_replica_map, local.environment, 0)}"
  local_replica_cnt   = "${lookup(var.environment_to_local_replica_cnt_map, local.environment, 0)}"
}


## Define different AWS providers in case you want, for example, create resources in different regions

provider "aws" {
   region     = "${local.primary_region}"
   alias      = "primary_region"
}

provider "aws" {
   region     = "${local.remote_region}"
   alias      = "remote_region"
}


module "rds" {
  source = "./resources"
      conf_postgres {
      "engine"                   ="postgres"
      "engine_version"           = "10.6"
      "port"                     = "5432"
      "identifier"               = "master"
      "allocated_storage"        = "50" # gigabytes
      "storage_type"             = "gp2"
      "multi_az"                 = true
      "publicly_accessible"      = false
      "storage_encrypted"        = false # you should always do this
      "skip_final_snapshot"      = true
      "backup_retention_period"  = "7"
      "maintenance_window"       = "Mon:00:00-Mon:03:00"
      "backup_window"            = "03:00-06:00"
      "database_name"            = "${local.dbname}"
      }

  admin_username     = "gds_admin"
  admin_password     = "${var.adminpassword}"
  instance_name      = "${local.environment}"
  instance_type      = "${local.instance_type}"
  remote_replica     = "${local.remote_replica}"
  local_replica_cnt  = "${local.local_replica_cnt}"
  primary_region     = "${local.primary_region}"
  remote_region      = "${local.remote_region}"
  local_subnet_group = "sgroup-1"
  remote_subnet_group = "sgroup-1"
  size = "${local.size}"

  providers = {
    aws.primary_region = "aws.primary_region"
    aws.remote_region = "aws.remote_region"
  }
}
