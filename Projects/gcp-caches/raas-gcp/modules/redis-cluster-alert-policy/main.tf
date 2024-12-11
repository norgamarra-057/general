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
  display_name = "${var.gcp_region} - Redis Cluster - OOM - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - OOM"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/Cluster\" AND (resource.labels.location = \"${var.gcp_region}\" ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.oom_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/memory/average_utilization\"")
      threshold_value = var.oom_warn_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - OOM - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_oom_critical" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - OOM - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - OOM"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/Cluster\" AND (resource.labels.location = \"${var.gcp_region}\" ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.oom_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/memory/average_utilization\"")
      threshold_value = var.oom_critical_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - OOM - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_oom_per_node_warning" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - OOM per Node - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - OOM per Node"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/ClusterNode\" AND (resource.labels.location = starts_with(\"${var.gcp_region}\") ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.oom_per_node_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/node/memory/utilization\"")
      threshold_value = var.oom_per_node_warn_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - OOM per Node - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_oom_per_node_critical" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - OOM per Node - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - OOM per Node"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/ClusterNode\" AND (resource.labels.location = starts_with(\"${var.gcp_region}\") ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.oom_per_node_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/node/memory/utilization\"")
      threshold_value = var.oom_per_node_critical_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - OOM per Node - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_cpu_warning" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - CPU - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - CPU"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/Cluster\" AND (resource.labels.location = \"${var.gcp_region}\" ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.cpu_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/cpu/average_utilization\"")
      threshold_value = var.cpu_warn_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - CPU - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_cpu_critical" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - CPU - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - CPU"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/Cluster\" AND (resource.labels.location = \"${var.gcp_region}\" ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.cpu_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/cpu/average_utilization\"")
      threshold_value = var.cpu_critical_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - CPU - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_max_connections_warning" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - Max Connections - WARN"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - Max Connections"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/Cluster\" AND (resource.labels.location = \"${var.gcp_region}\" ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.max_cons_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/clients/total_connected_clients\"")
      threshold_value = var.max_connect_warn_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "WARNING"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - Max Connections - WARN"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_max_connections_critical" {
  project = var.gcp_project_id
  display_name = "${var.gcp_region} - Redis Cluster - Max Connections - CRITICAL"
  combiner     = "OR"
  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
  conditions {
    display_name = "${var.gcp_region} - Cloud Memorystore Redis Cluster - Max Connections"
    condition_threshold {
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      duration   = "60s"
      filter     = format("%s%s%s","resource.type = \"redis.googleapis.com/Cluster\" AND (resource.labels.location = \"${var.gcp_region}\" ", join("", formatlist("AND resource.labels.cluster_id != \"%s\" ", var.max_cons_exclusion_list)), ") AND metric.type = \"redis.googleapis.com/cluster/clients/total_connected_clients\"")
      threshold_value = var.max_connect_critical_threshold_cluster
      trigger {
        count = 1
      }
    }
  }

  user_labels =  var.labels
  severity = "CRITICAL"
  documentation {
    subject = "${var.gcp_region} - GCP Redis Cluster - Max Connections - CRITICAL"
    mime_type = "text/markdown"
    content = "Dashboards URL: https://console.cloud.google.com/monitoring/dashboards?project=${var.gcp_project_id}"
  }
}