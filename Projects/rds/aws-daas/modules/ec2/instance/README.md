# EC2 Instance

This module provides any number of ec2 instances.

## Usage

### Single instance with default config

```hcl
module "ec2_instance" {
  source = "git::https://github.groupondev.com/terraform-modules/ec2.git//instance?ref=v1.1.0"
  owner  = "your-mail@groupon.com"
  usage  = "service::name"
  name   = "my-instance-A"
}
```

### 2 instances in eu-west-1 in public subnet

```hcl
module "ec2_instance" {
  source         = "git::https://github.groupondev.com/terraform-modules/ec2.git//instance?ref=v1.1.0"
  owner          = "your-mail@groupon.com"
  usage          = "service::name"
  instance_count = 2
  aws_region     = eu-west-1
  tier           = Public
  name           = "my-instance-B"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name to be used on all resources as prefix | string | n/a | yes |
| owner | Your groupon E-Mail | string | n/a | yes |
| usage | For what the instances are used | string | n/a | yes |
| ami | AMI to use for the instances | string | n/a | no |
| associate\_public\_ip\_address | If true, the EC2 instance will have associated public IP address | string | `"false"` | no |
| availability\_zone | In which availability zone to create the instances | string | `"a"` | no |
| aws\_region | In which region to create the instances | string | `"us-west-2"` | no |
| cpu\_credits | The credit option for CPU usage (unlimited or standard) | string | `"standard"` | no |
| disable\_api\_termination | If true, enables EC2 Instance Termination Protection | string | `"false"` | no |
| ebs\_block\_device | Additional EBS block devices to attach to the instance | list | `<list>` | no |
| ebs\_optimized | If true, the launched EC2 instance will be EBS-optimized | string | `"false"` | no |
| ephemeral\_block\_device | Customize Ephemeral (also known as Instance Store) volumes on the instance | list | `<list>` | no |
| iam\_instance\_profile | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. | string | `""` | no |
| instance\_count | Number of instances | string | `"1"` | no |
| instance\_initiated\_shutdown\_behavior | Shutdown behavior for the instance | string | `""` | no |
| instance\_type | EC2 instance type | string | `"t2.micro"` | no |
| ipv6\_address\_count | A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet. | string | `"0"` | no |
| key\_name | The ssh key name to use for the instance | string | `""` | no |
| monitoring | If true, the launched EC2 instance will have detailed monitoring enabled | string | `"false"` | no |
| placement\_group | The Placement Group to start the instance in | string | `""` | no |
| private\_ip | Private IP address to associate with the instance in a VPC | string | `""` | no |
| root\_block\_device | Customize details about the root block device of the instance. See Block Devices below for details | list | `<list>` | no |
| source\_dest\_check | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs. | string | `"true"` | no |
| tags | Additional tags for your instances | map | `<map>` | no |
| tenancy | The tenancy of the instance | string | `"default"` | no |
| tier | In which subnet tier to create the instances | string | `"App"` | no |
| use\_num\_suffix | Always append numerical suffix to instance name, even if instance_count is 1 | string | `"false"` | no |
| user\_data | The user data to provide when launching the instance | string | `""` | no |
| volume\_tags | A mapping of tags to assign to the devices created by the instance at launch time | map | `<map>` | no |
| vpc | In which VPC to create the instances | string | `"PrimaryVPC"` | no |
| vpc\_security\_group\_ids | A list of security group IDs to associate with | list | `<list>` | no |
| subnet_id | The VPC Subnet ID to launch in | string | n/a | no |
| subnet_ids | A list of VPC Subnet IDs to launch in | list | n/a | no |

## Outputs

| Name |
|------|
| arn |
| availability\_zone |
| instances |
| ipv6\_addresses |
| key\_name |
| network\_interface\_id |
| password\_data |
| placement\_group |
| primary\_network\_interface\_id |
| private\_dns |
| private\_ip |
| public\_dns |
| public\_ip |
| security\_groups |
| subnet\_id |
| vpc\_security\_group\_ids |
