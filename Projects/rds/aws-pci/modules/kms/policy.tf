data "aws_iam_policy_document" "gds_pci_kms_key" {
     statement {
          sid = "AccountAccess"
          principals {
            type = "AWS"
            identifiers = [
                 "arn:aws:iam::${var.account_id}:root"
                 ]
          }
          effect = "Allow"
          actions = ["kms:*"]
          resources = ["*"]
     } 
     statement {
          sid = "GDSAdminAccess"
          principals {
            type = "AWS"
            identifiers = [
                 "arn:aws:iam::${var.account_id}:role/${var.role_id}"
                 ]
          }
          effect = "Allow"
          actions = ["kms:*"]
          resources = ["*"]
     }
     statement {
          sid = "CrossAccountBackupAccess"
          principals {
            type = "AWS"
            identifiers = [
                 "arn:aws:iam::${var.cross_account_id}:root"
                 ]
          }
          effect = "Allow"
          actions = [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey",
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
          ]
          resources = ["*"]
     }
}
