locals {
  env_stage = var.env_stage == "stable" ? "staging" : "production"
}

data "google_dns_managed_zone" "dns-zone" {
  project = var.gcp_project_id
  name    = var.dns_managed_zone
}

resource "google_dns_record_set" "wrr_cname" {
  count        = length(var.cnames)
  project      = var.gcp_project_id
  name         = "${var.db_cname}-${element(var.cnames.*.db_access_type, count.index)}-${var.env_region}-${local.env_stage}-db.${data.google_dns_managed_zone.dns-zone.dns_name}"
  managed_zone = var.dns_managed_zone
  type         = "CNAME"
  ttl          = 300

  routing_policy {
    wrr {
      weight  = element(var.cnames.*.aws_weight, count.index)
      rrdatas = ["${element(var.cnames.*.aws_backend, count.index)}"]
    }

    wrr {
      weight  = element(var.cnames.*.gcp_weight, count.index)
      rrdatas = ["${element(var.cnames.*.gcp_backend, count.index)}"]
    }
  }
}