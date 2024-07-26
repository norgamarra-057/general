## Primary Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances" {
  count                   = "${var.local_replica_cnt +1}"
  identifier              = "${var.instance_name}-${count.index}"
  cluster_identifier      = "${aws_rds_cluster.master.id}"
  instance_class          = "${var.instance_type}"
  engine_version          = "5.7.12"
  engine                  = "aurora-mysql"
  provider                = "aws.primary_region"
  monitoring_interval     = 5
  monitoring_role_arn     = "arn:aws:iam::286052569778:role/grpn_all_rds_enhanced_monitoring"
  db_parameter_group_name = "ipg-${var.size}"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}

## Primary Region Aurorar cluster
resource "aws_rds_cluster" "master" {
  provider                        = "aws.primary_region"
  cluster_identifier       	      = "${var.instance_name}"
  skip_final_snapshot  		      = "true"
  engine               		      = "aurora-mysql"
  engine_version       		      = "5.7.12"
  database_name                   = "${var.database_name}"
  master_username             	  = "${var.admin_username}"
  master_password             	  = "${var.admin_password}"
  vpc_security_group_ids	      = ["${var.primary_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_stg_na_secgroup_id : data.terraform_remote_state.secgroups.sg_stg_emea_secgroup_id}"]
  backup_retention_period         = 7
  db_cluster_parameter_group_name = "cpg-${var.size}"
  db_subnet_group_name            = "${var.local_subnet_group}"
  deletion_protection             = "true"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}

## Remote Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances_replica" {
  provider            = "aws.remote_region"
  count               = "${var.remote_replica == 1 ? var.remote_replica_cnt +1: 0}"
  identifier          = "${var.instance_name}-replica-${count.index}"
  cluster_identifier  = "${aws_rds_cluster.replica.id}"
  instance_class      = "${var.instance_type}"
  engine_version      = "5.7.12"
  engine              = "aurora-mysql"
  monitoring_interval = 5
  monitoring_role_arn     = "arn:aws:iam::286052569778:role/grpn_all_rds_enhanced_monitoring"
  db_parameter_group_name = "ipg-${var.size}"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}

## Remote Region Aurora cluster
resource "aws_rds_cluster" "replica" {
  count                           = "${var.remote_replica}"
  depends_on                      = ["aws_rds_cluster_instance.cluster_instances"]
  provider                        = "aws.remote_region"
  cluster_identifier           	  = "${var.instance_name}-replica"
  skip_final_snapshot  		      = "true"
  engine               		      = "aurora-mysql"
  engine_version       		      = "5.7.12"
  #master_username             	  = "${var.admin_username}"
  #master_password             	  = "${var.admin_password}"
  vpc_security_group_ids	      = ["${var.remote_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_stg_na_secgroup_id : data.terraform_remote_state.secgroups.sg_stg_emea_secgroup_id}"]
  backup_retention_period         = 7
  db_cluster_parameter_group_name = "cpg-${var.size}"
  db_subnet_group_name            = "${var.remote_subnet_group}"
  replication_source_identifier   = "${aws_rds_cluster.master.arn}"
  deletion_protection             = "true"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}

data "terraform_remote_state" "secgroups" {
  backend = "s3"
  config = {
    bucket = "gds-rds-terraform-state"
    key    = "subnet-groups-state"
    region = "us-west-1"
    dynamodb_table = "daas-terraform-lock-table"
  }
}

