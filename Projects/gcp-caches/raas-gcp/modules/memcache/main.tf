resource "google_memcache_instance" "memcache-instance" {
  name               = var.cache_name
  region             = var.gcp_region
  project            = var.gcp_project_id
  memcache_version   = var.memcache_version
  display_name       = var.cache_display_name
  authorized_network = data.google_compute_network.memcache_network.id
  labels             = var.labels
  node_count         = var.node_count

  node_config {
    cpu_count      = var.cpu_count
    memory_size_mb = var.memory_size
  }
  maintenance_policy {
    weekly_maintenance_window {
      day      = "TUESDAY"
      duration = "10800s"
      start_time {
        hours   = 07
        minutes = 00
      }
    }
  }
}

data "google_compute_network" "memcache_network" {
  name    = var.vpc_name
  project = var.vpc_project_id
}


resource "google_dns_record_set" "dns" {
  name    = "${var.cache_name}-memcache.${var.environment == "stable" ? var.dns_name_stable : var.environment == "prod" ? var.dns_name_prod : var.dns_name_dev}"
  project = var.gcp_project_id
  type    = "A"
  ttl     = 300

  managed_zone = var.environment == "stable" ? var.managed_zone_stable : var.environment == "prod" ? var.managed_zone_prod : var.managed_zone_dev

  rrdatas = [split(":", google_memcache_instance.memcache-instance.discovery_endpoint)[0]]
}


#data "google_monitoring_notification_channel" "email_opsgenie" {
#  project = var.gcp_project_id
#  display_name = "RaaS Team Opsgenie"
#  type = "email"
#}
#
#data "google_monitoring_notification_channel" "email_raas" {
#  project = var.gcp_project_id
#  display_name = "RaaS Team Email"
#  type = "email"
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_oom_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Memcache Instance - OOM - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Memcache Instance - OOM"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"memcache_instance\" AND resource.label.\"instance_id\" = \"${google_memcache_instance.memcache-instance.id}\" AND metric.type = \"memcache.googleapis.com/node/memory/utilization\""
#      threshold_value = var.oom_warn_threshold
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "WARNING"
#  documentation {
#    subject = "GCP Memcache Instance - ${var.cache_name} - OOM - WARN"
#    mime_type = "text/markdown"
#    #content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_memcache_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_oom_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Memcache Instance - OOM - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Memcache Instance - OOM"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"memcache_instance\" AND resource.label.\"instance_id\" = \"${google_memcache_instance.memcache-instance.id}\" AND metric.type = \"memcache.googleapis.com/node/memory/utilization\""
#      threshold_value = var.oom_critical_threshold
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "CRITICAL"
#  documentation {
#    subject = "GCP Memcache Instance - ${var.cache_name} - OOM - CRITICAL"
#    mime_type = "text/markdown"
#    #content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_memcache_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_cpu_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Memcache Instance - CPU - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Memcache Instance - CPU"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"memcache_instance\" AND resource.label.\"instance_id\" = \"${google_memcache_instance.memcache-instance.id}\" AND metric.type = \"memcache.googleapis.com/node/cpu/utilization\""
#      threshold_value = var.cpu_warn_threshold
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "WARNING"
#  documentation {
#    subject = "GCP Memcache Instance - ${var.cache_name} - CPU - WARN"
#    mime_type = "text/markdown"
#    #content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_memcache_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_cpu_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Memcache Instance - CPU - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Memcache Instance - CPU"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"memcache_instance\" AND resource.label.\"instance_id\" = \"${google_memcache_instance.memcache-instance.id}\" AND metric.type = \"memcache.googleapis.com/node/cpu/utilization\""
#      threshold_value = var.cpu_critical_threshold
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "CRITICAL"
#  documentation {
#    subject = "GCP Memcache Instance - ${var.cache_name} - CPU - CRITICAL"
#    mime_type = "text/markdown"
#    #content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_memcache_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_max_connections_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Memcache Instance - Max Connections - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Memcache Instance - Max Connections"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"memcache_instance\" AND resource.label.\"instance_id\" = \"${google_memcache_instance.memcache-instance.id}\" AND metric.type = \"memcache.googleapis.com/node/active_connections\""
#      threshold_value = var.max_connect_warn_threshold
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "WARNING"
#  documentation {
#    subject = "GCP Memcache Instance - ${var.cache_name} - Max Connections - WARN"
#    mime_type = "text/markdown"
#    #content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_memcache_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_max_connections_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Memcache Instance - Max Connections - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Memcache Instance - Max Connections"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"memcache_instance\" AND resource.label.\"instance_id\" = \"${google_memcache_instance.memcache-instance.id}\" AND metric.type = \"memcache.googleapis.com/node/active_connections\""
#      threshold_value = var.max_connect_critical_threshold
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "CRITICAL"
#  documentation {
#    subject = "GCP Memcache Instance - ${var.cache_name} - Max Connections - CRITICAL"
#    mime_type = "text/markdown"
#    #content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_memcache_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}


resource "google_monitoring_dashboard" "dashboard_memcache" {
  project        = var.gcp_project_id
  dashboard_json = <<EOF
{
  "displayName": "Memcache Dashboard - ${var.cache_name} - ${var.gcp_region}",
  "dashboardFilters": [
    {
      "filterType": "RESOURCE_LABEL",
      "labelKey": "instance_id",
      "stringValue": "${var.cache_name}",
      "templateVariable": ""
    }
  ],
  "mosaicLayout": {
    "columns": 48,
    "tiles": [
      {
        "yPos": 48,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "CPU Usage",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/cpu/utilization\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 32,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Commands Count",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"command\"",
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/operation_count\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Memory Usage Ratio",
          "scorecard": {
            "gaugeView": {
              "lowerBound": 0,
              "upperBound": 1
            },
            "thresholds": [
              {
                "color": "YELLOW",
                "direction": "ABOVE",
                "label": "",
                "value": 0.8
              },
              {
                "color": "RED",
                "direction": "ABOVE",
                "label": "",
                "value": 0.9
              }
            ],
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_SUM",
                  "groupByFields": [],
                  "perSeriesAligner": "ALIGN_MEAN"
                },
                "filter": "metric.type=\"memcache.googleapis.com/node/memory/utilization\" resource.type=\"memcache_node\""
              }
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 16,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Keys",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/items\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 32,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Evictions",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/eviction_count\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 64,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Network Traffic",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/received_bytes_count\" resource.type=\"memcache_node\""
                  }
                }
              },
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/sent_bytes_count\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 64,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Active Connections",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/active_connections\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "yPos": 48,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Hits\\Misses",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"response_type\"",
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/operation_count\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "xPos": 24,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Memory Usage (%)",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/memory/utilization\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 16,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Memory Usage",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"used\"",
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/cache_memory\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "0 Unused 1 Used Memory",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 80,
        "width": 48,
        "height": 16,
        "widget": {
          "title": "Uptime",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"node_id\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"memcache.googleapis.com/node/uptime\" resource.type=\"memcache_node\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "",
              "scale": "LINEAR"
            }
          }
        }
      }
    ]
  },
  "labels": {${join(",", [for key, value in var.labels : "\"${key}\":\"${value}\""])}}
}

  EOF
}
