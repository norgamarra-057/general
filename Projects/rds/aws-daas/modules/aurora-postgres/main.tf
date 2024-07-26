# Lookup for default security group
data "aws_security_group" "sgpr" {
  name = "sgdaas"
}

data "aws_route53_zone" "groupondev" {
  name         = var.route53_zone_name
  private_zone = true
}
resource "aws_route53_record" "rw_cname" {
  count   = (var.cname != null && var.cluster_master_arn == "") ? 1 : 0
  zone_id = data.aws_route53_zone.groupondev.id
  name    = "gds-${var.cname}-rw"
  type    = "CNAME"
  ttl     = 1
  records = [aws_rds_cluster.master[0].endpoint]
}
resource "aws_route53_record" "ro_cname" {
  count   = (var.cname != null && var.cluster_master_arn == "") ? 1 : 0
  zone_id = data.aws_route53_zone.groupondev.id
  name    = "gds-${var.cname}-ro"
  type    = "CNAME"
  ttl     = 1
  records = [aws_rds_cluster.master[0].reader_endpoint]
}
resource "aws_route53_record" "ro_replica_cname" {
  count   = (var.cname != null && var.cluster_master_arn != "") ? 1 : 0
  zone_id = data.aws_route53_zone.groupondev.id
  name    = "gds-${var.cname}-ro"
  type    = "CNAME"
  ttl     = 1
  records = [aws_rds_cluster.replica[0].reader_endpoint]
}

## Primary Region Aurora cluster instances
resource "aws_rds_cluster_instance" "cluster_instances" {
  count                   = var.local_replica_cnt +1
  identifier              = "${var.app_name}-${count.index}"
  cluster_identifier      = var.cluster_master_arn == "" ? aws_rds_cluster.master[0].id : aws_rds_cluster.replica[0].id
  instance_class          = var.instance_type
  engine                  = var.engine
  engine_version          = var.engine_version
  monitoring_interval     = 5
  monitoring_role_arn     = join("",["arn:aws:iam::",var.account_id,":role/grpn_all_rds_enhanced_monitoring"])
  db_parameter_group_name = join("-",["ipg",join("", [var.engine, split(".",var.engine_version)[0]]), var.size])
  auto_minor_version_upgrade = "false"
  performance_insights_enabled    = var.performance_insights_enabled
  tags                 		      = {
                            	     environment : "${var.app_name}"
				     service_portal : join("",["https://services.groupondev.com/services/",var.tenantservice_tag])
			             jira: var.jira_tag
                                     Service: var.service_tag
                                     Owner: var.owner_tag
                                     TenantTeam: var.tenantteam_tag
                                     TenantService: var.tenantservice_tag
                         	    }
  lifecycle {
    ignore_changes = [engine_version]
  }
}

## Primary Region Aurora cluster - 
resource "aws_rds_cluster" "master" {
  count                           = var.cluster_master_arn == "" ? 1 : 0
  cluster_identifier              = var.app_name
  skip_final_snapshot             = "false"
  copy_tags_to_snapshot           = "true"
  engine               	          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = var.storage_encrypted
  database_name                   = var.db_name
  master_username             	  = var.admin_username
  master_password             	  = var.admin_password
  apply_immediately               = var.apply_immediately
  vpc_security_group_ids          = [data.aws_security_group.sgpr.id]
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  db_cluster_parameter_group_name = join("-",["cpg",join("", [var.engine, split(".",var.engine_version)[0]]), var.size])
  db_subnet_group_name            = var.local_subnet_group
  final_snapshot_identifier       = join("-",[var.app_name,"final-snapshot"])
  deletion_protection	          = "true"
  port                            = var.port
  source_region                   = var.source_region
  kms_key_id                      = var.kms_key_id
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                 		      = {
                            	     environment : "${var.app_name}"
			             service_portal : join("",["https://services.groupondev.com/services/",var.app_name])
			             jira: var.jira_tag
                                     Service: var.service_tag
                                     Owner: var.owner_tag
                                     TenantTeam: var.tenantteam_tag
                                     TenantService: var.tenantservice_tag
                         	       }
}

## Primary Region Aurora cluster
resource "aws_rds_cluster" "replica" {
  count                           = var.cluster_master_arn == "" ? 0 : 1
  cluster_identifier              = var.app_name
  skip_final_snapshot             = "false"
  copy_tags_to_snapshot           = "true"
  engine                          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = var.storage_encrypted
  apply_immediately               = var.apply_immediately
  vpc_security_group_ids          = [data.aws_security_group.sgpr.id]
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  db_cluster_parameter_group_name = join("-",["cpg",join("", [var.engine, split(".",var.engine_version)[0]]), var.size])
  db_subnet_group_name            = var.local_subnet_group
  final_snapshot_identifier       = join("-",[var.app_name,"final-snapshot"])
  deletion_protection             = "true"
  port                            = var.port
  replication_source_identifier   = var.cluster_master_arn
  source_region                   = var.source_region
  kms_key_id                      = var.kms_key_id
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                 		      = {
                            	     environment : "${var.app_name}"
			             service_portal : join("",["https://services.groupondev.com/services/",var.app_name])
			             jira: var.jira_tag
                                     Service: var.service_tag
                                     Owner: var.owner_tag
                                     TenantTeam: var.tenantteam_tag
                                     TenantService: var.tenantservice_tag
                         	       }
}
