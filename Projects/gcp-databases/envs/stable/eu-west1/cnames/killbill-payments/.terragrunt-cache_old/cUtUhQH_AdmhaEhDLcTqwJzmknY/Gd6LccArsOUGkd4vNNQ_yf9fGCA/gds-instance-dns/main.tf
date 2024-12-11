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


###############
# Data Sources
###############

data "google_dns_managed_zone" "dns-zone" {
  project = var.project_id
  name    = var.dns_managed_zone
}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

data "google_compute_instance" "gds-instance" {
  count = var.num_instances
  name    = "gds-${var.cluster_suffix}-gcp${count.index+1}"
  project = var.project_id
  zone    = var.zone == null ? data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)] : var.zone
}

resource "google_dns_record_set" "gds-instance-record" {
  count = var.num_instances
  name = "gds-${var.cluster_suffix}-gcp${count.index+1}.${data.google_dns_managed_zone.dns-zone.dns_name}"
  project = var.project_id
  type = "A"
  ttl = 300
  managed_zone = var.dns_managed_zone
  rrdatas = [
    data.google_compute_instance.gds-instance[count.index].network_interface.0.network_ip
  ]
}
