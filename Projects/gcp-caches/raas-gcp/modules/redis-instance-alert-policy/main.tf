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

data "google_redis_instance" "oom_exclusion_redis-instances" {
  count = length(var.oom_exclusion_list)
  project = var.gcp_project_id
  region = var.gcp_region
  name = var.oom_exclusion_list[count.index]
}

data "google_redis_instance" "cpu_exclusion_redis-instances" {
  count = length(var.cpu_exclusion_list)
  project = var.gcp_project_id
  region = var.gcp_region
  name = var.cpu_exclusion_list[count.index]
}

data "google_redis_instance" "max_cons_exclusion_redis-instances" {
  count = length(var.max_cons_exclusion_list)
  project = var.gcp_project_id
  region = var.gcp_region
  name = var.max_cons_exclusion_list[count.index]
}

resource "google_monitoring_alert_policy" "alert_policy_oom_warning" {
  project = var.gcp_project_id
  display_name = "Redis Instance - OOM - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "Cloud Memorystore Redis Instance - OOM"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis_instance\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", data.google_redis_instance.oom_exclusion_redis-instances[*].id)), " AND metric.type = \"redis.googleapis.com/stats/memory/usage_ratio\"")
      threshold_value = var.oom_warn_threshold_instance
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "GCP Redis Instance - OOM - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_oom_critical" {
  project = var.gcp_project_id
  display_name = "Redis Instance - OOM - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "Cloud Memorystore Redis Instance - OOM"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis_instance\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", data.google_redis_instance.oom_exclusion_redis-instances[*].id)), " AND metric.type = \"redis.googleapis.com/stats/memory/usage_ratio\"")
      threshold_value = var.oom_critical_threshold_instance
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "GCP Redis Instance - OOM - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}





resource "google_monitoring_alert_policy" "alert_policy_cpu_warning" {
  project = var.gcp_project_id
  display_name = "Redis Instance - CPU - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "Cloud Memorystore Redis Instance - CPU"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis_instance\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", data.google_redis_instance.cpu_exclusion_redis-instances[*].id)), " AND metric.type = \"redis.googleapis.com/stats/cpu_utilization\"")
      threshold_value = var.cpu_warn_threshold_instance
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "GCP Redis Instance - CPU - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_cpu_critical" {
  project = var.gcp_project_id
  display_name = "Redis Instance - CPU - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "Cloud Memorystore Redis Instance - CPU"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis_instance\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", data.google_redis_instance.cpu_exclusion_redis-instances[*].id)), " AND metric.type = \"redis.googleapis.com/stats/cpu_utilization\"")
      threshold_value = var.cpu_critical_threshold_instance
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "GCP Redis Instance - CPU - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}




resource "google_monitoring_alert_policy" "alert_policy_max_connections_warning" {
  project = var.gcp_project_id
  display_name = "Redis Instance - Max Connections - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "Cloud Memorystore Redis Instance - Max Connections"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis_instance\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", data.google_redis_instance.max_cons_exclusion_redis-instances[*].id)), " AND metric.type = \"redis.googleapis.com/stats/connections/total\"")
      threshold_value = var.max_connect_warn_threshold_instance
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "GCP Redis Instance - Max Connections - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_max_connections_critical" {
  project = var.gcp_project_id
  display_name = "Redis Instance - Max Connections - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "Cloud Memorystore Redis Instance - Max Connections"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis_instance\" ", join("", formatlist("AND resource.labels.instance_id != \"%s\" ", data.google_redis_instance.max_cons_exclusion_redis-instances[*].id)), " AND metric.type = \"redis.googleapis.com/stats/connections/total\"")
      threshold_value = var.max_connect_critical_threshold_instance
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "GCP Redis Instance - Max Connections - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}
