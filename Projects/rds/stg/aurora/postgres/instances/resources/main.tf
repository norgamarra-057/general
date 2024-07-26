
## Primary Region Security Group
resource "aws_security_group" "instance_sg" {
  provider    = "aws.primary_region"
  name        = "${var.instance_name}"
  description = "allow connections on port 3306"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

## Remote Region Security Group
resource "aws_security_group" "instance_sg_east1" {
  count  = "${var.remote_replica}"
  name        = "${var.instance_name}"
  description = "allow connections on port 3306"
  provider    = "aws.remote_region"
  vpc_id   = "${var.vpcid_east1}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

## Primary Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = "${var.local_replica_cnt}"
  identifier         = "aurora-${var.instance_name}-${count.index}"
  cluster_identifier = "${aws_rds_cluster.master.id}"
  instance_class     = "${var.instance_type}"
  engine_version     = "10.7-R1"
  engine             = "aurora-postgresql"
  provider    = "aws.primary_region"
}

## Aurora cluster in Primary Region
resource "aws_rds_cluster" "master" {
  provider                  = "aws.primary_region"
  cluster_identifier       	= "${var.instance_name}"
  skip_final_snapshot  		= "true"
  engine               		= "aurora-postgresql"
  engine_version       		= "10.7-R1"
  master_username             		= "${var.admin_username}"
  master_password             		= "${var.admin_password}"
  vpc_security_group_ids	= ["${aws_security_group.instance_sg.*.id}"]
  backup_retention_period   = 2
  db_cluster_parameter_group_name      = "cpg-${var.size}"
  db_subnet_group_name      = "${var.local_subnet_group}"
  tags                 		= {
                            	environment = "${var.instance_name}"
                         	}
}


## Remote Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances_replica" {
  provider    = "aws.remote_region"
  count              = "${var.remote_replica == 1 ? var.remote_replica_cnt : 0}"
  identifier         = "aurora-${var.instance_name}-replica-${count.index}"
  cluster_identifier = "${aws_rds_cluster.replica.id}"
  instance_class     = "${var.instance_type}"
  engine_version     = "10.7-R1"
  engine             = "aurora-postgresql"
}

## Aurora cluster in Remote Region
resource "aws_rds_cluster" "replica" {
  count  = "${var.remote_replica}"
  depends_on = ["aws_rds_cluster_instance.cluster_instances"]
  provider    = "aws.remote_region"
  cluster_identifier           		= "${var.instance_name}-replica"
  skip_final_snapshot  		= "true"
  engine               		= "aurora-postgresql"
  engine_version       		= "10.7-R1"
  master_username             		= "${var.admin_username}"
  master_password             		= "${var.admin_password}"
  vpc_security_group_ids	= ["${aws_security_group.instance_sg_east1.*.id}"]
  backup_retention_period   = 2
  db_cluster_parameter_group_name      = "cpg-${var.size}"
  db_subnet_group_name      = "${var.remote_subnet_group}"
  replication_source_identifier = "${aws_rds_cluster.master.arn}"
  tags                 		= {
                            	environment = "${var.instance_name}"
                         	}
}


#provider "mysql" {
#    endpoint = "${aws_rds_cluster_instance.cluster_instances.0.endpoint}"
#    username = "${var.admin_username}"
#    password = "${var.admin_password}"
#}

#resource "mysql_user" "ro_user" {
#  user               = "ro_user"
#  host               = "%"
#  plaintext_password = "S3Cre7pAss!"
#}

#resource "mysql_grant" "ro_user" {
#  user       = "${mysql_user.ro_user.user}"
#  host       = "${mysql_user.ro_user.host}"
#  database   = "${var.instance_name}"
#  privileges = ["SELECT"]
#}
#
#resource "mysql_user" "rw_user" {
#  user               = "rw_user"
#  host               = "%"
#  plaintext_password = "S3Cre7pAss!"
#}
#
#resource "mysql_grant" "rw_user" {
#  user       = "${mysql_user.rw_user.user}"
#  host       = "${mysql_user.rw_user.host}"
#  database   = "${var.instance_name}"
#  privileges = ["SELECT","UPDATE","DELETE","INSERT"]
#}
