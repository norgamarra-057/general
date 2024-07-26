terraform {
    source = "../../../../../../modules/ec2/instance"
}

include {
	path = find_in_parent_folders()
}

# If module specific variables need to be defined, these variables need to be defined in a "module-specific.tfvars" file inside the same directory

inputs = {
  owner                = "gds@groupon.com"
  usage                = "GDS::AWS-DaaS"
  name                 = "gds-stg-rds05"
  tier	               = "App"
  key_name             = "gds-stable-us-west-1-ec2"
  private_ip           = "10.213.0.209"
  instance_type        = "r5.4xlarge"
  iam_instance_profile = "grpn-all-ec2-dba"

  root_block_device = [
    {
      volume_size = "500"
    }
  ]

  ebs_block_device = [
    {
      device_name = "/dev/xvdb"
      volume_size = "1000"
    }
  ]

  user_data     = <<-EOF
                  #!/usr/bin/sh
                  sudo hostname gds-stg-rds05
                  sudo mkfs.xfs /dev/xvdb
                  sudo mkdir /var/groupon
                  sudo mkdir /var/groupon/data
                  sudo mount /dev/xvdb /var/groupon/data
                  EOF
}

