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

output "google_dns_record_set_rw_cname" {
  description = "RW CNAME created for database"
  value       = google_dns_record_set.wrr_cname[0].name
}

output "google_dns_record_set_ro_cname" {
  description = "RO CNAME created for database"
  value       = google_dns_record_set.wrr_cname[1].name
}