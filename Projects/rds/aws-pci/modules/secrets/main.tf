resource "aws_secretsmanager_secret" "gds" {
   name                = var.secret_name
   description         = "GDS main account access information"
   policy              = data.aws_iam_policy_document.gds_secrets_key.json
   tags                = {
                     owner: var.owner_tag
                     tenant_team: var.tenantteam_tag
                     service: var.service_tag
                  }
}
