  terraform {
    source = "../../../../../modules/backup-plan"
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  #prevent_destroy = true

  dependencies {
    paths = []
  }

inputs = {
  backup_vault = "TestBkpVault"
  backup_plan_name = "TestBackupPlan"
  backup_cron = "0 10 1 * ? *"
  lc_options = [{
    "cold-storage" = "365"
    "delete" = "720"
  }]
  tag_key = "backup_1_year"
  tag_value = "yes"
  resources_list = ["arn:aws:rds:us-west-1:549734399709:db:dminorsingle"]
}
