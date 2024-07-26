terraform {
    source = "../../../../../../../aws-pci/modules/aurora-mysql"
}

include {
	path = find_in_parent_folders()
}

# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  instance_type       = "db.r6g.large"
  local_replica_cnt   = "1"
  size                = "small"
  db_name             = "mysql_demo"
  cname               = "pci-prod-emea"
  engine              = "aurora-mysql"
  engine_version      = "8.0.mysql_aurora.3.01.1"
  cluster_master_arn  = ""
  multi_az            = true 
  port                = 3306
  allocated_storage   = ""
  storage_encrypted   = true
  kms_key_id          = "arn:aws:kms:eu-west-1:496778485823:key/mrk-12a2a49f362a4ddda435578971b6972d"
  account_id          = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  Backup_tag          = "pci-gds-bacup"
  jira_tag            = "GDS-34987"
  service_tag         = "daas_mysql"
  service_portal_tag  = "daas_mysql"
  owner_tag           = "gds@groupon.com"
  tenantteam_tag      = "pci-api@groupon.com"
  tenantservice_tag   = "pci-api"
}
