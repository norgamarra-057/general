data "aws_iam_policy_document" "gds_secrets_key" {
      statement {
         effect = "Allow"
         principals {
            type = "AWS" 
            identifiers = ["arn:aws:iam::${var.account_id}:role/${var.role_id}"]
        }
        actions = [
            "secretsmanager:ListSecrets",
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:TagResource",
            "secretsmanager:UnTagResource",
            "secretsmanager:CreateSecret",
            "secretsmanager:DeleteSecret",
            "secretsmanager:PutSecretValue",
            "secretsmanager:UpdateSecret",
            "secretsmanager:DeleteResourcePolicy",
            "secretsmanager:PutResourcePolicy",
            "secretsmanager:ValidateResourcePolicy",
            "secretsmanager:GetResourcePolicy"
            ]
        resources  = ["arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:${var.secret_name}"]
    } 
    statement {
         effect = "Deny"
         principals {
            type = "AWS"
            identifiers =  ["*"]
         }
         actions = [
            "secretsmanager:ListSecrets",
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:TagResource",
            "secretsmanager:UnTagResource",
            "secretsmanager:CreateSecret",
            "secretsmanager:DeleteSecret",
            "secretsmanager:PutSecretValue",
            "secretsmanager:UpdateSecret",
            "secretsmanager:DeleteResourcePolicy",
            "secretsmanager:PutResourcePolicy",
            "secretsmanager:ValidateResourcePolicy",
            "secretsmanager:GetResourcePolicy"
            ]
         resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:${var.secret_name}"]
         condition {
             test     = "StringNotLike"
             variable = "aws:PrincipalArn"
             values   =  [
                "arn:aws:iam::${var.account_id}:role/${var.role_id}"
                ]
            }
        }
}
