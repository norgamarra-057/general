locals {
  env_stage = var.environment == "stable" ? "staging" : "production"
}

resource "google_dns_record_set" "wrr_cname" {
  count        = length(var.cnames)
  project      = var.gcp_project_id
  #name         = "${var.cache_cname}-${element(var.cnames.*.db_access_type, count.index)}-${var.environment}-${local.env_stage}-db.${data.google_dns_managed_zone.dns-zone.dns_name}"
  name         = var.cache_cname
  managed_zone = var.environment == "stable" ? var.managed_zone_stable : var.managed_zone_prod
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