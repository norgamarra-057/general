locals {
  ami                = var.ami != "" ? var.ami : data.aws_ami.default.image_id
  is_t_instance_type = replace(var.instance_type, "/^t[23]{1}\\..*$/", "1") == "1" ? true : false
}

resource "aws_instance" "ec2" {
  count                = var.instance_count
  ami                  = local.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  user_data            = var.user_data
  iam_instance_profile = var.iam_instance_profile

  # Use default SG if no SG id list has been provided
//  vpc_security_group_ids      = length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids : split(",", data.aws_security_group.default.id)
  vpc_security_group_ids      = split(",", length(var.vpc_security_group_ids) > 0 ? join(",", var.vpc_security_group_ids) : data.aws_security_group.default.id)
  subnet_id                   = var.subnet_id == "" && length(var.subnet_ids) == 0 ? element(tolist(data.aws_subnet_ids.subnets.ids), count.index) : element(distinct(compact(concat([var.subnet_id], var.subnet_ids))), count.index)
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  ipv6_address_count          = var.ipv6_address_count
  ebs_optimized               = var.ebs_optimized
  volume_tags                 = var.volume_tags

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  monitoring                           = var.monitoring
  source_dest_check                    = var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy

  # user_data_base64 = var.user_data_base64 not possible since it conflicts with user_data. revisit in tf 0.12 when omit is possible
  # ipv6_addresses   = var.ipv6_addresses

  tags = merge(
    {
      "Name" = var.instance_count > 1 || var.use_num_suffix ? format("%s-%d", var.name, count.index + 1) : var.name
    },
    var.tags,
    local.default_tags,
  )

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  lifecycle {
    create_before_destroy = true

    // ignore tags which get automatically applied
    ignore_changes = [
      tags.CreatorId,
      tags.CreatorName,
      tags.Env,
    ]
  }
}
