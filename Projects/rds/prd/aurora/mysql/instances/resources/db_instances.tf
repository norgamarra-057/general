data "terraform_remote_state" "secgroups" {
  backend = "s3"
  config = {
    bucket = "gds-rds-prod-terraform-state"
    key    = "subnet-groups-state-grpn-prod"
    region = "us-west-1"
    dynamodb_table = "daas-terraform-lock-table"
  }
}


## Primary Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = "${var.local_replica_cnt +1}"
  identifier         = "${var.instance_name}-${count.index}"
  cluster_identifier = "${aws_rds_cluster.master.id}"
  instance_class     = "${var.instance_type}"
  #engine_version     = "5.7.mysql_aurora.2.04.6"
#  engine_version     = "5.7.12"
#  engine             = "aurora-mysql"
  provider           = "aws.primary_region"
  monitoring_interval = 5
  #performance_insights_enabled = true
  auto_minor_version_upgrade = true
  monitoring_role_arn     = "arn:aws:iam::497256801702:role/grpn_all_rds_enhanced_monitoring"
  db_parameter_group_name = "ipg-${var.size}"
  apply_immediately   = 1
  tags                 		  = {
                            	     instance = "${var.instance_name}"
                         	    }
}

## Primary Region Aurora cluster
resource "aws_rds_cluster" "master" {
  provider                        = "aws.primary_region"
  cluster_identifier       	      = "${var.instance_name}"
  skip_final_snapshot  		      = "true"
  engine               		      = "${var.engine}"
#  engine               		      = "aurora-mysql"
  #engine_version       		      = "5.7.mysql_aurora.2.04.6"
#  engine_version       		      = "5.7.12"
  engine_version                  = "${var.engine_version}"
  database_name                   = "${var.database_name}"
  master_username             	  = "${var.admin_username}"
  master_password             	  = "${var.admin_password}"
  vpc_security_group_ids	      = ["${var.primary_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_prd_na_secgroup_id : data.terraform_remote_state.secgroups.sg_prd_emea_secgroup_id}"]
  backup_retention_period         = 7
  preferred_maintenance_window = "Mon:17:00-Mon:20:00"
  apply_immediately   = 1
  db_cluster_parameter_group_name = "cpg-${var.size}"
  db_subnet_group_name            = "${var.local_subnet_group}"
  deletion_protection             = "true"
  tags                 		  = {
                            	     instance = "${var.instance_name}"
                         	    }
}

## Remote Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances_replica" {
  provider           = "aws.remote_region"
  count              = "${var.remote_replica == 1 ? var.remote_replica_cnt +1: 0}"
  identifier         = "${var.instance_name}-replica-${count.index}"
  cluster_identifier = "${aws_rds_cluster.replica.id}"
  instance_class     = "${var.instance_type}"
#  engine_version     = "5.7.12"
  #engine_version     = "5.7.mysql_aurora.2.04.6"
#  engine              = "${var.engine}"
#  engine             = "aurora-mysql"
  monitoring_interval = 5
  apply_immediately   = 1
  #performance_insights_enabled = true
  auto_minor_version_upgrade = true
  monitoring_role_arn     = "arn:aws:iam::497256801702:role/grpn_all_rds_enhanced_monitoring"
  db_parameter_group_name = "ipg-${var.size}"
  tags                 		  = {
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
#  engine               		      = "aurora-mysql"
  engine               		      = "${var.engine}"
  #engine_version       		      = "5.7.mysql_aurora.2.04.6"
  engine_version                  = "${var.engine_version}"
  #master_username             	  = "${var.admin_username}"
  #master_password             	  = "${var.admin_password}"
  vpc_security_group_ids	      = ["${var.remote_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_prd_na_secgroup_id : data.terraform_remote_state.secgroups.sg_prd_emea_secgroup_id}"]
  backup_retention_period         = 7
  apply_immediately   = 1
  preferred_maintenance_window = "Mon:17:00-Mon:20:00"
  db_cluster_parameter_group_name = "cpg-${var.size}"
  db_subnet_group_name            = "${var.remote_subnet_group}"
  replication_source_identifier   = "${aws_rds_cluster.master.arn}"
  deletion_protection             = "true"
  tags                 		  = {
                            	     instance = "${var.instance_name}"
                         	    }
}
