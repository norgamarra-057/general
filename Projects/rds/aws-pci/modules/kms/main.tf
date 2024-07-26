resource "aws_kms_key" "gds" {
   description         = "GDS PCI encryption Key"
   key_usage           = "ENCRYPT_DECRYPT"
   multi_region        = "true"
   enable_key_rotation = "true"
   tags                = {
                     owner: var.owner_tag
                     tenant_team: var.tenantteam_tag
                     service: var.service_tag
                  }
   policy              = data.aws_iam_policy_document.gds_pci_kms_key.json
}

resource "aws_kms_alias" "gds_alias" {
  name          = "alias/gds_pci_rds_key"
  target_key_id = aws_kms_key.gds.key_id
}

