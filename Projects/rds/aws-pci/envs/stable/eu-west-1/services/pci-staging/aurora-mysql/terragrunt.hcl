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
  cname               = "pci-staging"
  engine              = "aurora-mysql"
  engine_version      = "8.0.mysql_aurora.3.01.0"
  cluster_master_arn  = ""
  multi_az            = true 
  port                = 3306
  allocated_storage   = ""
  storage_encrypted   = true
  kms_key_id          = "arn:aws:kms:eu-west-1:683644855136:key/mrk-6fe6be5fb0ab4b5fa688efd312957169"
  account_id          = get_aws_account_id()
  maintenance_window  = "mon:00:00-mon:03:00"
  jira_tag            = "GDS-33985"
  service_tag         = "daas_mysql"
  service_portal_tag  = "daas_mysql"
  owner_tag           = "gds@groupon.com"
  tenantteam_tag      = "pci-devel@groupon.com"
  tenantservice_tag   = "pci-api"
}
