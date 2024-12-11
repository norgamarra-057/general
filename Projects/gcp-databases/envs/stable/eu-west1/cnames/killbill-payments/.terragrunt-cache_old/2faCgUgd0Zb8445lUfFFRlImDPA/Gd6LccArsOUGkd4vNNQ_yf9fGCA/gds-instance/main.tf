/**
 * Copyright 2018 Google LLC
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

#provider "google" {

  #project = var.project_id
  #region  = var.region
#}

module "ansible_instance_template" {
  name_prefix     = "gds-instance-template"
  source          = "../gds-instance-template"
  subnetwork      = var.subnetwork
  service_account = var.service_account
  machine_type    = var.machine_type
  cluster_suffix  = var.cluster_suffix
  project_id      = var.project_id
  labels = { "service" : "${var.label_service_name}", "owner" : "${var.label_owner}"}
  additional_disks = [
    {
      disk_name    = "gds-${var.cluster_suffix}-data"
      device_name  = "gds-${var.cluster_suffix}-data"
      auto_delete  = false
      boot         = false
      disk_size_gb = var.data_volume_size
      disk_type    = "pd-ssd"
      disk_labels  = { "name" : "gds-${var.cluster_suffix}-data", "owner" : "gds", "service" : "daas"  }
    }
  ]
}

module "ansible_compute_instance" {
  source              = "../compute-instance"
  region              = var.gcp_region
  zone                = var.zone
  subnetwork          = var.subnetwork
  num_instances       = var.num_instances
  hostname            = "ansible"
  instance_template   = module.ansible_instance_template.self_link
  deletion_protection = false
  cluster_suffix = var.cluster_suffix
  labels = { "service" : "${var.label_service_name}", "owner" : "${var.label_owner}"}

  #access_config = [{
  #  nat_ip       = var.nat_ip
  #  network_tier = var.network_tier
  #}, ]
}
