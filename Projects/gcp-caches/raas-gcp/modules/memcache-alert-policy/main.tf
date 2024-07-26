data "google_monitoring_notification_channel" "email_opsgenie" {
  project = var.gcp_project_id
  display_name = "RaaS Team Opsgenie"
  type = "email"
}

data "google_monitoring_notification_channel" "email_raas" {
  project = var.gcp_project_id
  display_name = "RaaS Team Email"
  type = "email"
}

resource "google_monitoring_alert_policy" "alert_policy_oom_warning" {
  project = var.gcp_project_id
  display_name = "Memcache Instance - OOM - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "Cloud Memorystore Memcache Instance - OOM"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"memcache_node\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", var.oom_exclusion_list)), " AND metric.type = \"memcache.googleapis.com/node/memory/utilization\"")
      threshold_value = var.oom_warn_threshold_memcache
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "GCP Memcache Instance - OOM - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_oom_critical" {
  project = var.gcp_project_id
  display_name = "Memcache Instance - OOM - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "Cloud Memorystore Memcache Instance - OOM"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"memcache_node\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", var.oom_exclusion_list)), " AND metric.type = \"memcache.googleapis.com/node/memory/utilization\"")
      threshold_value = var.oom_critical_threshold_memcache
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "GCP Memcache Instance - OOM - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_cpu_warning" {
  project = var.gcp_project_id
  display_name = "Memcache Instance - CPU - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "Cloud Memorystore Memcache Instance - CPU"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"memcache_node\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", var.cpu_exclusion_list)), " AND metric.type = \"memcache.googleapis.com/node/cpu/utilization\"")
      threshold_value = var.cpu_warn_threshold_memcache
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "GCP Memcache Instance - CPU - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_cpu_critical" {
  project = var.gcp_project_id
  display_name = "Memcache Instance - CPU - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "Cloud Memorystore Memcache Instance - CPU"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"memcache_node\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", var.cpu_exclusion_list)), " AND metric.type = \"memcache.googleapis.com/node/cpu/utilization\"")
      threshold_value = var.cpu_critical_threshold_memcache
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "GCP Memcache Instance - CPU - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_max_connections_warning" {
  project = var.gcp_project_id
  display_name = "Memcache Instance - Max Connections - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "Cloud Memorystore Memcache Instance - Max Connections"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"memcache_node\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", var.cpu_exclusion_list)), " AND metric.type = \"memcache.googleapis.com/node/active_connections\"")
      threshold_value = var.max_connect_warn_threshold_memcache
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "GCP Memcache Instance - Max Connections - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_max_connections_critical" {
  project = var.gcp_project_id
  display_name = "Memcache Instance - Max Connections - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "Cloud Memorystore Memcache Instance - Max Connections"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"memcache_node\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", var.cpu_exclusion_list)), " AND metric.type = \"memcache.googleapis.com/node/active_connections\"")
      threshold_value = var.max_connect_critical_threshold_memcache
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "GCP Memcache Instance - Max Connections - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}
