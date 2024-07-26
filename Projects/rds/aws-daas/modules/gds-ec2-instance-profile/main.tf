resource "aws_iam_instance_profile" "gds_instance_profile" {
  name = "grpn-gds-admin-instance-profile"
  role = aws_iam_role.gds_instance_profile_role.name
}

resource "aws_iam_role" "gds_instance_profile_role" {
  name                 = "grpn-gds-admin-instance-profile-role"
  assume_role_policy   = data.aws_iam_policy_document.gds_ec2_assume.json
  permissions_boundary = "arn:aws:iam::${var.aws_account_id}:policy/grpn-boundary-gds-admin-policy"
  tags = {
    "Owner"   = "gds@groupon.com"
    "Service" = "GDS"
  }
}

resource "aws_iam_policy" "gds_instance_profile_policy" {
  name        = "grpn-gds-admin-instance-profile-policy"
  description = "Custom IAM policy for GDS EC2 instance profiles"
  policy      = data.aws_iam_policy_document.gds_instance_profile_policy.json
}

resource "aws_iam_role_policy_attachment" "gds_instance_profile_policy_attachment" {
  policy_arn = aws_iam_policy.gds_instance_profile_policy.arn
  role       = aws_iam_role.gds_instance_profile_role.name
}

## EC2 instance assumes this role
data "aws_iam_policy_document" "gds_ec2_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

## For all permissions within jump host to create cluster
data "aws_iam_policy_document" "gds_instance_profile_policy" {
  statement {
    sid = ""

    actions = [
      "iam:UpdateRoleDescription",
      "iam:UpdateRole"
    ]
    resources = ["*"]
  }

  statement {
    sid = ""
      
    actions = [
      "arn:aws:iam::${var.aws_account_id}:role/grpn_all_rds_enhanced_monitoring",
      "arn:aws:iam::${var.aws_account_id}:role/grpn-all-ec2-dba",
      "arn:aws:iam::${var.aws_account_id}:role/grpn-all-dba-admin"
    ]
    resources = ["*"]
  }
  
  statement {
    sid = ""
    
    actions = [
      "iam:SimulatePrincipalPolicy",
      "iam:SimulateCustomPolicy",
      "iam:List*",
      "iam:Get*",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:GenerateCredentialReport"
    ]
    resources = ["*"]
  }

  statement {
    sid = ""

    not_actions = [
      "organizations:*",
      "iam:*",
      "ec2:RestoreAddressToClassic",
      "ec2:ResetNetworkInterfaceAttribute",
      "ec2:ReplaceRouteTableAssociation",
      "ec2:ReplaceRoute",
      "ec2:ReplaceNetworkAclEntry",
      "ec2:ReplaceNetworkAclAssociation",
      "ec2:RejectVpcPeeringConnection",
      "ec2:MoveAddressToVpc",
      "ec2:ModifyVpcEndpoint",
      "ec2:ModifyVpcAttribute",
      "ec2:ModifySubnetAttribute",
      "ec2:EnableVpcClassicLink",
      "ec2:EnableVgwRoutePropagation",
      "ec2:DisassociateRouteTable",
      "ec2:DisassociateAddress",
      "ec2:DisableVpcClassicLink",
      "ec2:DisableVgwRoutePropagation",
      "ec2:DetachVpnGateway",
      "ec2:DetachInternetGateway",
      "ec2:DetachClassicLinkVpc",
      "ec2:DeleteVpnGateway",
      "ec2:DeleteVpnConnectionRoute",
      "ec2:DeleteVpnConnection",
      "ec2:DeleteVpcPeeringConnection",
      "ec2:DeleteVpcEndpoints",
      "ec2:DeleteVpc",
      "ec2:DeleteSubnet",
      "ec2:DeleteRouteTable",
      "ec2:DeleteRoute",
      "ec2:DeleteNetworkAclEntry",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteNatGateway",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteFlowLogs",
      "ec2:DeleteDhcpOptions",
      "ec2:DeleteCustomerGateway",
      "ec2:CreateVpnGateway",
      "ec2:CreateVpnConnectionRoute",
      "ec2:CreateVpnConnection",
      "ec2:CreateVpcPeeringConnection",
      "ec2:CreateVpcEndpoint",
      "ec2:CreateVpc",
      "ec2:CreateSubnet",
      "ec2:CreateRouteTable",
      "ec2:CreateRoute",
      "ec2:CreateNetworkAclEntry",
      "ec2:CreateNetworkAcl",
      "ec2:CreateNatGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateFlowLogs",
      "ec2:CreateDhcpOptions",
      "ec2:CreateCustomerGateway",
      "ec2:AttachVpnGateway",
      "ec2:AttachInternetGateway",
      "ec2:AttachClassicLinkVpc",
      "ec2:AssociateRouteTable",
      "ec2:AssociateDhcpOptions",
      "ec2:AcceptVpcPeeringConnection"
      ]
      resources = ["*"]
    }

    statement {
      sid = ""

      actions = ["iam:CreateServiceSpecificCredential"]
      resources = ["*"]
    }
    
    statement {
      sid = ""
        
      actions = ["organizations:DescribeOrganization"]
      resources = ["*"]
    }
    
    statement {
          sid = ""
          effect = "Deny"
          actions = ["route53domains:*"]
          resources = ["*"]
    }

   statement {
      sid = ""
    
      actions = ["iam:CreateServiceLinkedRole"]
      resources = ["*"]
      condition  {
        test     = "StringLike" 
        variable = "iam:AWSServiceName" 
        values   = ["*"]
      }
    }

    statement {
      sid = ""
      effect = "Deny"
      actions = [
        "ec2:ReleaseAddress",
        "ec2:DisassociateAddress",
        "ec2:AssociateAddress",
        "ec2:AllocateAddress"
      ]
      resources = ["*"]
    }

    statement {
      sid = ""
      effect = "Deny"
      actions = ["ec2:RunInstances"]
      resources = ["*"]
     condition  {
        test     = "StringLike"
        variable = "ec2:ResourceTag/Tier"
        values   = ["Public"]
      }
    }

    statement {
      sid = ""
      actions = [
        "iam:RemoveRoleFromInstanceProfile",
        "iam:DeleteInstanceProfile",
        "iam:CreateInstanceProfile",
        "iam:AddRoleToInstanceProfile"
      ]
      resources = ["*"]
    }

    statement {
      sid = ""
      effect = "Deny"
      actions = ["directconnect:*"]
      resources = ["*"]
    }

    statement {
      sid = "IAMAccess"

      actions = [
        "iam:CreateServiceLinkedRole"
      ]
      resources = ["*"]
    }

    statement {
      sid = "IAMCreateRole"

      actions = [
        "iam:AttachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:PutRolePolicy",
        "iam:UpdateRole",
        "iam:UpdateRoleDescription"
      ]
      resources = ["*"]
    }
}
  
