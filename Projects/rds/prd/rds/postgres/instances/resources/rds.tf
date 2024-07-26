data "terraform_remote_state" "secgroups" {
  backend = "s3"
  config = {
    bucket = "gds-rds-prod-terraform-state"
    key    = "subnet-groups-state-grpn-prod"
    region = "us-west-1"
    dynamodb_table = "daas-terraform-lock-table"
  }
}

resource "aws_db_instance" "master" {
  provider                 = "aws.primary_region"
  engine                   = "${var.conf_postgres["engine"]}"
  engine_version           = "${var.conf_postgres["engine_version"]}"
  port                     = "${var.conf_postgres["port"]}"
  identifier               = "${var.instance_name}"
  username                 = "${var.admin_username}"
  password                 = "${var.admin_password}"
  allocated_storage        = "${var.conf_postgres["allocated_storage"]}"
  storage_type             = "${var.conf_postgres["storage_type"]}"
  multi_az                 = "${var.conf_postgres["multi_az"]}"
  publicly_accessible      = "${var.conf_postgres["publicly_accessible"]}"
  storage_encrypted        = "${var.conf_postgres["storage_encrypted"]}"
  skip_final_snapshot      = "${var.conf_postgres["skip_final_snapshot"]}"
  vpc_security_group_ids   = ["${var.primary_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_prd_na_secgroup_id : data.terraform_remote_state.secgroups.sg_prd_emea_secgroup_id}"]
  backup_retention_period  = "${var.conf_postgres["backup_retention_period"]}"
  maintenance_window       = "${var.conf_postgres["maintenance_window"]}"
  backup_window            = "${var.conf_postgres["backup_window"]}"
  parameter_group_name     = "postg-pg-${var.size}"
  instance_class           = "${var.instance_type}"
  db_subnet_group_name     = "${var.local_subnet_group}"
  monitoring_interval      = 5
  monitoring_role_arn      = "arn:aws:iam::497256801702:role/grpn_all_rds_enhanced_monitoring"
  deletion_protection      = "true"
  name                     = "${var.conf_postgres["database_name"]}"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}

resource "aws_db_instance" "replicas" {
  provider                 = "aws.primary_region"
  count                    = "${var.local_replica_cnt}"
  engine                   = "${var.conf_postgres["engine"]}"
  engine_version           = "${var.conf_postgres["engine_version"]}"
  port                     = "${var.conf_postgres["port"]}"
  identifier               = "${var.instance_name}-${count.index+1}"
  instance_class           = "${var.instance_type}"
  allocated_storage        = "${var.conf_postgres["allocated_storage"]}"
  storage_type             = "${var.conf_postgres["storage_type"]}"
  multi_az                 = "${var.conf_postgres["multi_az"]}"
  publicly_accessible      = "${var.conf_postgres["publicly_accessible"]}"
  storage_encrypted        = "${var.conf_postgres["storage_encrypted"]}"
  skip_final_snapshot      = "${var.conf_postgres["skip_final_snapshot"]}"
  vpc_security_group_ids   = ["${var.primary_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_prd_na_secgroup_id : data.terraform_remote_state.secgroups.sg_prd_emea_secgroup_id}"]
  replicate_source_db      = "${aws_db_instance.master.identifier}"
  parameter_group_name     = "postg-pg-${var.size}"
  monitoring_interval = 5
  monitoring_role_arn     = "arn:aws:iam::497256801702:role/grpn_all_rds_enhanced_monitoring"
  deletion_protection      = "true"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}

resource "aws_db_instance" "master_remote" {
  count                    = "${var.remote_replica == 1 ? 1 : 0}"
  provider                 = "aws.remote_region"
  engine                   = "${var.conf_postgres["engine"]}"
  engine_version           = "${var.conf_postgres["engine_version"]}"
  port                     = "${var.conf_postgres["port"]}"
  identifier               = "${var.instance_name}"
  allocated_storage        = "${var.conf_postgres["allocated_storage"]}"
  storage_type             = "${var.conf_postgres["storage_type"]}"
  multi_az                 = "${var.conf_postgres["multi_az"]}"
  publicly_accessible      = "${var.conf_postgres["publicly_accessible"]}"
  storage_encrypted        = "${var.conf_postgres["storage_encrypted"]}"
  skip_final_snapshot      = "${var.conf_postgres["skip_final_snapshot"]}"
  vpc_security_group_ids   = ["${var.remote_region == "us-west-1" ? data.terraform_remote_state.secgroups.sg_prd_na_secgroup_id : data.terraform_remote_state.secgroups.sg_prd_emea_secgroup_id}"]
  maintenance_window       = "${var.conf_postgres["maintenance_window"]}"
  parameter_group_name     = "postg-pg-${var.size}"
  instance_class           = "${var.instance_type}"
  db_subnet_group_name     = "${var.remote_subnet_group}"
  replicate_source_db      = "${aws_db_instance.master.arn}"
  monitoring_interval      = 5
  monitoring_role_arn      = "arn:aws:iam::497256801702:role/grpn_all_rds_enhanced_monitoring"
  deletion_protection      = "true"
  tags                            = {
                                     instance = "${var.instance_name}"
                                    }
}
