/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#########
# Locals
#########

locals {
  source_image         = var.source_image != "" ? var.source_image : "centos-stream-9-v20240709"
  source_image_family  = var.source_image_family != "" ? var.source_image_family : "centos-stream-9"
  source_image_project = var.source_image_project != "" ? var.source_image_project : "centos-cloud"

  boot_disk = [
    {
      source_image = var.source_image != "" ? format("${local.source_image_project}/${local.source_image}") : format("${local.source_image_project}/${local.source_image_family}")
      disk_size_gb = var.disk_size_gb
      disk_type    = var.disk_type
      disk_labels  = var.disk_labels
      auto_delete  = var.auto_delete
      boot         = "true"
    },
  ]

  all_disks = concat(local.boot_disk, var.additional_disks)

  # NOTE: Even if all the shielded_instance_config or confidential_instance_config
  # values are false, if the config block exists and an unsupported image is chosen,
  # the apply will fail so we use a single-value array with the default value to
  # initialize the block only if it is enabled.
  shielded_vm_configs = var.enable_shielded_vm ? [true] : []

  gpu_enabled            = var.gpu != null
  alias_ip_range_enabled = var.alias_ip_range != null
  on_host_maintenance = (
    var.preemptible || var.enable_confidential_vm || local.gpu_enabled || var.spot
    ? "TERMINATE"
    : var.on_host_maintenance
  )
  automatic_restart = (
    # must be false when preemptible or spot is true
    var.preemptible || var.spot ? false : var.automatic_restart
  )
  preemptible = (
    # must be true when preemtible or spot is true
    var.preemptible || var.spot ? true : false
  )
}

####################
# Instance Template
####################
resource "google_compute_instance_template" "tpl" {
  name_prefix             = "${var.name_prefix}-${var.cluster_suffix}-"
  project                 = var.project_id
  machine_type            = var.machine_type
  labels                  = var.labels
  #metadata                = var.metadata
  #metadata = {
  #"ssh-keys" = file("${path.module}/../gds-instance/<yourkey>.pub")
  #}

  metadata = {
    ssh-keys = <<EOF
      ec2-user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpcGGhWZ8SyVlIV15PEUpxTKprCCB9a8fhCCbBOyilnJAQA8AEa7LTkOt1L09QCqG+Dgq3bjCZngX22MRpTnsXkSQS9z2l/yEGVh4IdnFlz9A1zJbuxYQB0vSoJRkxTRO4fhFhph8H5OayB8Q0gpw7faslKSQq89PDjOLbuaonX7l8nuz+9B19GMOT4ac0g3HPJ99cbzE8ctp9GhJZBSBC4rIvKg39AvlMCYjEkCioRiOusBa3/ThOlus95RsDUgORjTVUzjtYn/rOyG/u9j/Vp2lchtyrqBBH6A7/wcsRjLZZGw9O9umu0eaqvXGks16rjsUocAkfO+5ONrWCxzYX krkinnal@C02X2NCPJG5H.group.on
      mohjamal:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRhrhfesJU75cBn9qIIcnzmdfeKBsTIq8LcsrtoL/MEIkTOPqKxFagzNvPaJ+XTIw66wZacju5AVPfRNXIZ0xeX1As7Fw3kHGKAk68HrX/Kot6EUgbxuEm5Yq04unx0htRTA9e4OMszOKWJk8jyyOaJDr8ivLAVf+XYvaH/EqX0sOVLpCB7AE4/eCIOvqlLux7L4D2qsKJL4UvHXywKHWxYZmNgPofWMcKM2mZQZudOwlSLWzKOMcAbTikXqA+Prei23OiLLih2vtQc4A8rh1y2m/7WYjiL/rWSsOKOM2MoGTs7r+BesButiI5mFTCyqeUQE9wceTXQGGiPI7qMi0PKyum6G3jC29AsryfAnN2Ig3Ni837ilmi2ovBQPmn6mjGxinVvHRdlpoeDo0otlgi31zN5z220477/fhcYdvE8kDmJqX4y10YBiDZsOiF5FMOcR0vGK8zVjJBNaEZkC/etLl5uQJWxQmy4ODWVtAZGHvMhADZTzz9LzWx+yU/P3RYvFEbIEdia4ONSrUU3e3gNiiH/6W15ba5ou5jfgvJ5QWHH+VfpLri9w0Vsmaw2GBap0lIRxU7Sv8Y7KFUAIOtlV99o13vAenxNOFd6JdM0P9wxS2duuDfp+WxoWPX/iNuGYOZV+cnQ8pGinElNkqi7pT3oBZkVpULGiH0jguPfw== mohjamal@192.168.1.23
      fkalamidas:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDqT2lhmLUyqMIvr0lXQ7ovOBzDMEGlC3TabkQZnM8nnZ4hGGjZuXROzy8pv3q/O8IBX+vJyLbOJUuKXXMc3K3oQTecaZIGBr0qB7nmjKSZtgYa6kqryE5utNWgi8SXFxVBMFHjKX1Sq0WhKc4QiUYOeDjqhJlm9St9NqmeAmIEwU8qohSmgLPIJv0rkWjZGEhXNVU7mq1anUfu5kHDY6+0afrUZx1T0EVL5Yfqp7BtW7kc+VR00ZrlJExTAExyBV0YjllIzQrs9eItBSuMgBDiCPPMXqYxVmx0gTXERnysLf/tA7oxvzmcRvdaV/0ocVdVNrh/Tb/Q9Bg0zLqTQfs7 fkalamidas@groupon.com
      c_ngamarra:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMxSueYV5YyYJueVFZwBwoEGZ4u62wGq2IhiZSDj9xpfyNp05d9fixSKCgbKyXjv03NVsUG+A59l/n10FYn6V4MUDFdmRNB0+oRZLJzji+5dVhKhlA3lTnskVUvYG3yWiLppRhWvGqzB7Z++7jFfIbP/iEalg4TELQvKWCYw5OphxajMD+C2gkovY9xgVv/7XGbYfdvPnpEmkzotMYbUGI1Kw6qBHkM9iTPivh542u2xHmv/1oogtpezbrtO+3kDiQmzV2pvifUqsrVX47zKhIw0ouHdMgDNTqeH82tZO5kKm66YJsMmpb62U75Tbod6dQs/e6EzJ2p+d4huVVekv7xwXPPqvmxoKCEi44K6cew//CsFu/vKfbAdDe858Gtr/NMXM3IpdXzfpY/uIzMvz3+VfJdsPOqdToPogreHgLY/HcveOimyKik75cpyF4mJvMl02C+8/akgTW/USmj85Rnv4TZQUfTFJ/Bt/RkPZkAw1XDTfSw3o3Mtrr6lVBguk= c_ngamarra@c-ngamarras-MacBook-Pro.local
    EOF
  }

  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  metadata_startup_script = file("${path.module}/../gds-instance/init.sh.tpl")

  region                  = var.region
  min_cpu_platform        = var.min_cpu_platform
  dynamic "disk" {
    for_each = local.all_disks
    content {
      auto_delete  = lookup(disk.value, "auto_delete", null)
      boot         = lookup(disk.value, "boot", null)
      device_name  = lookup(disk.value, "device_name", null)
      disk_name    = lookup(disk.value, "disk_name", null)
      disk_size_gb = lookup(disk.value, "disk_size_gb", lookup(disk.value, "disk_type", null) == "local-ssd" ? "375" : null)
      disk_type    = lookup(disk.value, "disk_type", null)
      interface    = lookup(disk.value, "interface", lookup(disk.value, "disk_type", null) == "local-ssd" ? "NVME" : null)
      mode         = lookup(disk.value, "mode", null)
      source       = lookup(disk.value, "source", null)
      source_image = lookup(disk.value, "source_image", null)
      type         = lookup(disk.value, "disk_type", null) == "local-ssd" ? "SCRATCH" : "PERSISTENT"
      labels       = lookup(disk.value, "disk_labels", null)

      dynamic "disk_encryption_key" {
        for_each = compact([var.disk_encryption_key == null ? null : 1])
        content {
          kms_key_self_link = var.disk_encryption_key
        }
      }
    }
  }

  dynamic "service_account" {
    for_each = var.service_account == null ? [] : [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = length(var.network_ip) > 0 ? var.network_ip : null
    nic_type           = var.nic_type
    stack_type         = var.stack_type
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
    dynamic "ipv6_access_config" {
      for_each = var.ipv6_access_config
      content {
        network_tier = ipv6_access_config.value.network_tier
      }
    }
    dynamic "alias_ip_range" {
      for_each = local.alias_ip_range_enabled ? [var.alias_ip_range] : []
      content {
        ip_cidr_range         = alias_ip_range.value.ip_cidr_range
        subnetwork_range_name = alias_ip_range.value.subnetwork_range_name
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.additional_networks
    content {
      network            = network_interface.value.network
      subnetwork         = network_interface.value.subnetwork
      subnetwork_project = network_interface.value.subnetwork_project
      network_ip         = length(network_interface.value.network_ip) > 0 ? network_interface.value.network_ip : null
      nic_type           = network_interface.value.nic_type
      stack_type         = network_interface.value.stack_type
      queue_count        = network_interface.value.queue_count
      dynamic "access_config" {
        for_each = network_interface.value.access_config
        content {
          nat_ip       = access_config.value.nat_ip
          network_tier = access_config.value.network_tier
        }
      }
      dynamic "ipv6_access_config" {
        for_each = network_interface.value.ipv6_access_config
        content {
          network_tier = ipv6_access_config.value.network_tier
        }
      }
      dynamic "alias_ip_range" {
        for_each = network_interface.value.alias_ip_range
        content {
          ip_cidr_range         = alias_ip_range.value.ip_cidr_range
          subnetwork_range_name = alias_ip_range.value.subnetwork_range_name
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = "true"
  }

  scheduling {
    preemptible                 = local.preemptible
    automatic_restart           = local.automatic_restart
    on_host_maintenance         = local.on_host_maintenance
    provisioning_model          = var.spot ? "SPOT" : null
    instance_termination_action = var.spot ? "STOP" : null
  }

  advanced_machine_features {
    enable_nested_virtualization = var.enable_nested_virtualization
    threads_per_core             = var.threads_per_core
  }

  dynamic "shielded_instance_config" {
    for_each = local.shielded_vm_configs
    content {
      enable_secure_boot          = lookup(var.shielded_instance_config, "enable_secure_boot", shielded_instance_config.value)
      enable_vtpm                 = lookup(var.shielded_instance_config, "enable_vtpm", shielded_instance_config.value)
      enable_integrity_monitoring = lookup(var.shielded_instance_config, "enable_integrity_monitoring", shielded_instance_config.value)
    }
  }

  confidential_instance_config {
    enable_confidential_compute = var.enable_confidential_vm
  }

  network_performance_config {
    total_egress_bandwidth_tier = var.total_egress_bandwidth_tier
  }

  dynamic "guest_accelerator" {
    for_each = local.gpu_enabled ? [var.gpu] : []
    content {
      type  = guest_accelerator.value.type
      count = guest_accelerator.value.count
    }
  }
}
