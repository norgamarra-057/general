# Lookup for default security group
data "aws_security_group" "sgpr" {
  name                     = "sgdaas"
}

data "aws_route53_zone" "groupondev" {
  name         = var.route53_zone_name
  private_zone = true
}
resource "aws_route53_record" "rw_cname" {
  count   = (var.cname != null && var.replicate_source_db == "") ? 1 : 0
  zone_id = data.aws_route53_zone.groupondev.id
  name    = "gds-${var.cname}-rw"
  type    = "CNAME"
  ttl     = 1
  records = [aws_db_instance.master.address]
}
resource "aws_route53_record" "ro_cname" {
  count   = (var.cname != null && var.replicate_source_db == "") ? var.local_replica_cnt : 0
  zone_id = data.aws_route53_zone.groupondev.id
  name    = "gds-${var.cname}-ro"
  type    = "CNAME"
  ttl     = 1
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = "replica${count.index}"
  records = [aws_db_instance.replicas[count.index].address]
}
resource "aws_route53_record" "replica_cname" {
  count   = (var.cname != null && var.replicate_source_db != "") ? 1 : 0
  zone_id = data.aws_route53_zone.groupondev.id
  name    = "gds-${var.cname}-ro"
  type    = "CNAME"
  ttl     = 1
  records = [aws_db_instance.master.address]
}

resource "aws_db_instance" "master" {
  engine                   = var.engine
  engine_version           = var.engine_version
  port                     = var.port
  identifier               = var.app_name
  allocated_storage        = var.allocated_storage
  max_allocated_storage    = var.max_allocated_storage
  storage_type             = var.storage_type
  apply_immediately        = var.apply_immediately
  iops                     = var.iops
  multi_az                 = var.multi_az
  publicly_accessible      = var.publicly_accessible
  storage_encrypted        = var.storage_encrypted
  skip_final_snapshot      = var.skip_final_snapshot
  vpc_security_group_ids   = [data.aws_security_group.sgpr.id]
  maintenance_window       = var.maintenance_window
  parameter_group_name     = join("-",["ipg",join("",["postgres",substr(var.engine_version,0,2)]),var.size])
  instance_class           = var.instance_type
  db_subnet_group_name     = var.local_subnet_group
  monitoring_interval      = 5
  monitoring_role_arn      = join("",["arn:aws:iam::",var.account_id,":role/grpn_all_rds_enhanced_monitoring"])
  replicate_source_db      = var.replicate_source_db
  name			           = var.db_name
  auto_minor_version_upgrade = "false"
  allow_major_version_upgrade = var.allow_major_version_upgrade
  performance_insights_enabled    = var.performance_insights_enabled
  tags                     = {
                               environment : "${var.app_name}"
			       service_portal : join("",["https://services.groupondev.com/services/",var.tenantservice_tag])
			       jira: var.jira_tag
			       Service: var.service_tag
			       Owner: var.owner_tag
                               TenantTeam: var.tenantteam_tag
                               TenantService: var.tenantservice_tag
                            }
  copy_tags_to_snapshot	   = "true"
  deletion_protection      = "true"
username = (var.replicate_source_db == "" ? var.admin_username : "")
password = (var.replicate_source_db == "" ? var.admin_password : "")

backup_retention_period = (var.replicate_source_db == "" ? var.backup_retention_period : 0)
backup_window = (var.replicate_source_db == "" ? var.backup_window : "")
  kms_key_id               = var.kms_key_id
}

resource "aws_db_instance" "replicas" {
  count                    = (var.replicate_source_db == "" ? var.local_replica_cnt : 0)
  engine                   = var.engine
  engine_version           = var.engine_version
  port                     = var.port
  identifier               = "${var.app_name}-${count.index+1}"
  instance_class           = var.instance_type
  allocated_storage        = var.allocated_storage
  max_allocated_storage    = var.max_allocated_storage
  storage_type             = var.storage_type
  apply_immediately        = var.apply_immediately
  iops                     = var.iops
  multi_az                 = var.multi_az
  publicly_accessible      = var.publicly_accessible
  storage_encrypted        = var.storage_encrypted
  skip_final_snapshot      = var.skip_final_snapshot
  vpc_security_group_ids   = [data.aws_security_group.sgpr.id]
  replicate_source_db      = aws_db_instance.master.identifier
  parameter_group_name     = join("-",["ipg",join("",["postgres",substr(var.engine_version,0,2)]),var.size])
  monitoring_interval      = 5
  monitoring_role_arn      = join("",["arn:aws:iam::",var.account_id,":role/grpn_all_rds_enhanced_monitoring"])
  auto_minor_version_upgrade = "false"
  allow_major_version_upgrade = var.allow_major_version_upgrade
  performance_insights_enabled    = var.performance_insights_enabled
  tags                     = {
                               environment:"${var.app_name}"
			       service_portal : join("",["https://services.groupondev.com/services/",var.tenantservice_tag])
			       jira: var.jira_tag
			       Service: var.service_tag
			       Owner: var.owner_tag
                               TenantTeam: var.tenantteam_tag
                               TenantService: var.tenantservice_tag

                            }
  copy_tags_to_snapshot	   = "true"
  deletion_protection      = "true"
  kms_key_id               = var.kms_key_id
}

#
# Aurora read replica
#

resource "aws_rds_cluster" "aurora_replica_cluster" {
  count                    = (var.aurora_replica_cnt > 0 ? 1 : 0)
  db_subnet_group_name     = var.local_subnet_group
  engine                   = var.aurora_engine
  engine_version           = var.engine_version
  port                     = var.port
  cluster_identifier       = "${var.app_name}-aurora"
  apply_immediately        = var.apply_immediately
  skip_final_snapshot      = var.skip_final_snapshot
  vpc_security_group_ids   = [data.aws_security_group.sgpr.id]
  storage_encrypted        = var.storage_encrypted
  replication_source_identifier = aws_db_instance.master.arn
  allow_major_version_upgrade   = var.allow_major_version_upgrade
  tags                     = {
                               environment:"${var.app_name}"
                               service_portal : join("",["https://services.groupondev.com/services/",var.tenantservice_tag])
                               jira: var.jira_tag
                               Service: var.service_tag
                               Owner: var.owner_tag
                               TenantTeam: var.tenantteam_tag
                               TenantService: var.tenantservice_tag
                             }
  copy_tags_to_snapshot    = "true"
  deletion_protection      = "true"
}

resource "aws_rds_cluster_instance" "aurora_replicas_instances" {
  count                           = (var.replicate_source_db == "" ? var.aurora_replica_cnt : 0)
  identifier                      = "${var.app_name}-aurora-${count.index+1}"
  cluster_identifier              = aws_rds_cluster.aurora_replica_cluster[count.index].id
  instance_class                  = var.aurora_instance_type
  publicly_accessible             = var.publicly_accessible
  engine                          = var.aurora_engine
  engine_version                  = var.engine_version
  db_subnet_group_name            = var.local_subnet_group
  monitoring_interval             = 5
  monitoring_role_arn             = join("",["arn:aws:iam::",var.account_id,":role/grpn_all_rds_enhanced_monitoring"])
  auto_minor_version_upgrade      = "false"
  performance_insights_enabled    = var.performance_insights_enabled
  tags                     = {
                               environment:"${var.app_name}"
                               service_portal : join("",["https://services.groupondev.com/services/",var.tenantservice_tag])
                               jira: var.jira_tag
                               Service: var.service_tag
                               Owner: var.owner_tag
                               TenantTeam: var.tenantteam_tag
                               TenantService: var.tenantservice_tag
                             }
  copy_tags_to_snapshot    = "true"
}

