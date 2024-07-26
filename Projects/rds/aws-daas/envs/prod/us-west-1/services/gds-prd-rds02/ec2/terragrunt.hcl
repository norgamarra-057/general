terraform {
    source = "../../../../../../modules/ec2/instance"
}

include {
	path = find_in_parent_folders()
}

# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  owner                = "gds@groupon.com"
  tags  	       = {"ssh-group":"gds-rds-prod"}
  usage                = "GDS::AWS-DaaS"
  name                 = "gds-prd-rds02"
  tier	               = "App"
  key_name             = "gds-prod-us-west-1-ec2"
  private_ip           = "10.211.12.39"
  instance_type        = "r5d.large"
  iam_instance_profile = "grpn-all-ec2-dba"

  root_block_device = [
    {
      volume_size = "500"
    }
  ]

  ebs_block_device = [
    {
      device_name = "/dev/xvdb"
      volume_size = "2000"
    }
  ]
  user_data     = <<-EOF
                  #!/usr/bin/sh
                  sudo hostname gds-prd-rds02
                  sudo mkfs.xfs /dev/xvdb
                  sudo mkdir /var/groupon
                  sudo mkdir /var/groupon/data
                  sudo mount /dev/xvdb /var/groupon/data
                  EOF
}

