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
  name                 = "gds-prd-jump01"
  tier	               = "App"
  key_name             = "gds-prod-us-west-1-ec2"
  private_ip           = "10.211.5.175"
  instance_type        = "t2.xlarge"

  root_block_device = [
    {
      volume_size = "500"
    }
  ]
}

