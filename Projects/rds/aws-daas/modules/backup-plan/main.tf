terraform {
  backend "s3" {}
}

## Backup Vault
resource "aws_backup_vault" "rds_backup_vault" {
  name        = var.backup_vault
}

## Backup plan definition
## See the following link for CRON format: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions
## Creating backup rules from the AWS Console allows to copy backups to another region. This doesn't seem to be available on Terraform.

resource "aws_backup_plan" "rds_custom_backups" {
  name = var.backup_plan_name

  rule {
    rule_name         = "RDSCustomBackups_rule_1"
    target_vault_name = aws_backup_vault.rds_backup_vault.name
    schedule          = join("",["cron(",var.backup_cron,")"])

    dynamic "lifecycle" {
      for_each = var.lc_options
      content {
        cold_storage_after = lifecycle.value["cold-storage"]
        delete_after = lifecycle.value["delete"]
      }
    }
    #lifecycle         {
    #    cold_storage_after = var.cold_storage_after
    #    delete_after = var.delete_after
    #}
  }
}


## Backup IAM role

resource "aws_iam_role" "backup_role" {
  name               = "BackupRole"
  assume_role_policy = <<POLICY
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": ["sts:AssumeRole"],
          "Effect": "allow",
          "Principal": {
            "Service": ["backup.amazonaws.com"]
          }
        }
      ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup_role_pa" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}


## Backup resources assigment

# By tag
resource "aws_backup_selection" "instances_by_tag" {
  count       = (var.tag_key == "" ? 0 : 1)
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "RDSInstancesByTag"
  plan_id      = aws_backup_plan.rds_custom_backups.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.tag_key
    value = var.tag_value
  }
}

# By resource id
resource "aws_backup_selection" "specific_instance" {
  count       = (length(var.resources_list) == 0 ? 0 : 1)
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "RDSInstacesByID"
  plan_id      = aws_backup_plan.rds_custom_backups.id
  resources = var.resources_list
}
