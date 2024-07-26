resource "aws_secretsmanager_secret" "gds" {
   name                = "gds_main_account"
   description         = "GDS main account access information"
   policy              = data.aws_iam_policy_document.gds_secrets_key.json
   replica {
      region           = var.aws_region_sec
   }
   tags                = {
                     owner: var.owner_tag
                     tenant_team: var.tenantteam_tag
                     service: var.service_tag
                  }
}
