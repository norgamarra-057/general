
variable "account_id" {
  description = "The acccount ID that is set in account-level.tfvars"
  default     = ""
}

variable "availability_zone" {
  description = "In which availability zone to create the instances"
  default     = "a"
}

variable "vpc" {
  description = "In which VPC to create the instances"
  default     = "PrimaryVPC"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
  default     = []
}

variable "tier" {
  description = "In which subnet tier to create the instances"
  default     = "App"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
}

variable "use_num_suffix" {
  description = "Always append numerical suffix to instance name, even if instance_count is 1"
  default     = false
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI to use for the instances"
  default     = ""
}

variable "owner" {
  description = "Your groupon E-Mail"
  type        = string
}

variable "usage" {
  description = "For what the instances are used"
  type        = string
}

variable "tags" {
  description = "Additional tags for your instances"
  type        = map(string)
  default     = {}
}

variable "instance_count" {
  description = "Number of instances"
  default     = 1
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  default     = ""
}

variable "tenancy" {
  description = "The tenancy of the instance"
  default     = "default"
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  default     = false
}

variable "key_name" {
  description = "The ssh key name to use for the instance"
  default     = ""
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = ""
}

#variable "user_data_base64" {
#  description = "The user data (base64 encoded) to provide when launching the instance"
#  default     = ""
#}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  default     = false
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  default     = ""
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  default     = 0
}

#variable "ipv6_addresses" {
#  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
#  default     = []
#}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(map(string))
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  default     = "standard"
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  default     = ""
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  default     = true
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}
/*
# hack for input validation. see https://github.com/hashicorp/terraform/issues/15469#issuecomment-343499242
resource "null_resource" "region_validation" {
  count = contains(local.valid_regions, var.aws_region) == true ? 0 : 1

  "ERROR: The region can only be: ${join(", ", local.valid_regions)} - got: ${var.aws_region}" = true
}

resource "null_resource" "az_validation" {
  count = contains(local.valid_availability_zones, var.availability_zone) == true ? 0 : 1

  "ERROR: The availability_zone can only be: ${join(", ", local.valid_availability_zones) - got: ${var.availability_zone}" = true
}

resource "null_resource" "tier_validation" {
  count = contains(local.valid_tiers, var.tier) == true ? 0 : 1

  "ERROR: The tier can only be: ${join(", ", local.valid_tiers) - got: ${var.tier}" = true
}

resource "null_resource" "owner_validation" {
  count = replace(var.owner, "/(?i)^[[:alnum:]._-]+@groupon.com$/", "") == "" ? 0 : 1

  "ERROR: Invalid owner email address. Must be your @groupon.com address: ${var.owner}" = true
}

resource "null_resource" "tenancy_validation" {
  count = contains(local.valid_tenancies, var.tenancy) == true ? 0 : 1

  "ERROR: The tenancy can only be: ${join(", ", local.valid_tenancies) - got: ${var.tenancy}" = true
}

resource "null_resource" "cpu_credits_validation" {
  count = contains(local.valid_cpu_credits, var.cpu_credits) == true ? 0 : 1

  "ERROR: cpu_credits can only be: ${join(", ", local.valid_cpu_credits) - got: ${var.cpu_credits}" = true
}

resource "null_resource" "shutdown_behavior_validation" {
  count = contains(local.valid_shutdown_behavior, var.instance_initiated_shutdown_behavior) == true ? 0 : 1

  "ERROR: shutdown_behavior can only be: ${join(", ", local.valid_shutdown_behavior) - got: ${var.instance_initiated_shutdown_behavior}" = true
}
*/
