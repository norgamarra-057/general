data "aws_iam_policy_document" "gds_secrets_key" {
      statement {
         effect = "Allow"
         principals {
            type = "AWS" 
            identifiers = [
            "arn:aws:iam::${var.account_id}:role/grpn-all-dba-admin", 
            "arn:aws:iam::${var.account_id}:role/grpn-all-dba-ro",
            "arn:aws:iam::${var.account_id}:role/grpn-all-ec2-dba"
            ]
        }
        actions = ["secretsmanager:*"]
        resources  = ["arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:gds_main_account"]
    } 
    statement {
         effect = "Deny"
         principals {
            type = "AWS"
            identifiers =  ["*"]
         }
         actions = ["secretsmanager:*"]
         resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:gds_main_account"]
         condition {
             test     = "StringNotLike"
             variable = "aws:PrincipalArn"
             values   =  [
                "arn:aws:iam::${var.account_id}:role/grpn-all-dba-admin", 
                "arn:aws:iam::${var.account_id}:role/grpn-all-dba-ro",
                "arn:aws:iam::${var.account_id}:role/grpn-all-ec2-dba" 
                ]
            }
        }
}
