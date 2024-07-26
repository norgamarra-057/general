
## Persist terraform state in S3. Also, use a DynamoDB table to handle locking.

terraform {
  backend "s3" {
    bucket         = "gds-rds-terraform-state"
    key            = "postgres-aurora-state"
    region         = "us-west-1"
    dynamodb_table = "daas-terraform-lock-table"
  }
}


## The following 'locals' block is basically checking on which workspace we are, and making mapping chained variables. Note that we have defined the necessary maps in variables.tf 

locals {
  environment        = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  instance_type      = "${lookup(var.environment_to_insttype_map, local.environment, "dev")}"
  size               = "${var.environment_to_size_map[local.environment]}"
  primary_region     = "${lookup(var.environment_to_primary_region_map, local.environment, "none")}"
  remote_region      = "${lookup(var.environment_to_remote_region_map, local.environment, "none")}"
  local_vpcid        = "${lookup(var.region_to_vpcid_map, local.primary_region, " ")}"
  remote_vpcid       = "${lookup(var.region_to_vpcid_map, local.remote_region, " ")}"
}


## Define different AWS providers in case you want, for example, create resources in different regions

provider "aws" {
   region     = "${local.primary_region}"
   alias      = "primary_region"
}

provider "aws" {
   access_key = "${var.access_key}"
   secret_key = "${var.secret_key}"
   region     = "us-east-1"
   alias      = "pythian"
}

provider "aws" {
   region     = "${local.remote_region}"
   alias      = "remote_region"
}


module "rds-instance" {
# source             = "git::ssh://git@github.com/gabocic/gitests.git//rds_instance"
  source             = "./resources"
  vpcid              = "${local.local_vpcid}"
  vpcid_east1        = "${local.remote_vpcid}"
  admin_username     = "foo"
  admin_password     = "${var.adminpassword}"
  instance_name      = "${local.environment}"
  instance_type      = "${local.instance_type}"
  remote_replica     = 0
  local_replica_cnt  = 1
  remote_replica_cnt = 1
  primary_region     = "${local.local_region}"
  remote_region      = "${local.remote_region}"
  local_subnet_group  = "sgroup-1"
  remote_subnet_group = "sgroup-1"
  size = "${local.size}"

  providers = {
    aws.primary_region = "aws.primary_region"
    aws.remote_region = "aws.remote_region"
  }


}

#output "endpoint" {
#  value = "${rds-instance.aws_rds_cluster.master.cluster_members}"
#}

