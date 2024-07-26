resource "google_redis_cluster" "redis-cluster" {
  name           = var.cache_name
  shard_count    = var.shard_count
  psc_configs {
    network = data.google_compute_network.redis_network.id
  }
  region  = var.gcp_region
  replica_count = var.replica_count
  project = var.gcp_project_id
  node_type = var.node_type
  transit_encryption_mode = "TRANSIT_ENCRYPTION_MODE_DISABLED"
  authorization_mode = "AUTH_MODE_DISABLED"
  }

data "google_compute_network" "redis_network" {
  name    = var.vpc_name
  project = var.vpc_project_id
}

resource "google_dns_record_set" "dns" {
  name = "${var.cache_name}.${var.environment == "stable" ? var.dns_name_stable : var.dns_name_prod}"
  project = var.gcp_project_id
  type = "A"
  ttl = 300

  managed_zone = var.environment == "stable" ? var.managed_zone_stable : var.managed_zone_prod
  
  rrdatas = [google_redis_cluster.redis-cluster.discovery_endpoints[0].address]
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
#  display_name = "${var.cache_name} - Redis Cluster - OOM - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Cluster - OOM"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis.googleapis.com/Cluster\" AND resource.labels.cluster_id = \"${var.cache_name}\" AND metric.type = \"redis.googleapis.com/cluster/memory/average_utilization\""
#      threshold_value = var.oom_warn_threshold / 100
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "WARNING"
#  documentation {
#    subject = "GCP Redis Cluster - ${var.cache_name} - OOM - WARN"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_cluster.id)[3]};duration=PT1H?f.rlabel.cluster_id=${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_oom_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Cluster - OOM - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Cluster - OOM"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis.googleapis.com/Cluster\" AND resource.labels.cluster_id = \"${var.cache_name}\" AND metric.type = \"redis.googleapis.com/cluster/memory/average_utilization\""
#      threshold_value = var.oom_critical_threshold / 100
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "CRITICAL"
#  documentation {
#    subject = "GCP Redis Cluster - ${var.cache_name} - OOM - CRITICAL"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_cluster.id)[3]};duration=PT1H?f.rlabel.cluster_id=${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_cpu_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Cluster - CPU - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Cluster - CPU"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis.googleapis.com/Cluster\" AND resource.labels.cluster_id = \"${var.cache_name}\" AND metric.type = \"redis.googleapis.com/cluster/cpu/average_utilization\""
#      threshold_value = var.cpu_warn_threshold / 100
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "WARNING"
#  documentation {
#    subject = "GCP Redis Cluster - ${var.cache_name} - CPU - WARN"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_cluster.id)[3]};duration=PT1H?f.rlabel.cluster_id=${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_cpu_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Cluster - CPU - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Cluster - CPU"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis.googleapis.com/Cluster\" AND resource.labels.cluster_id = \"${var.cache_name}\" AND metric.type = \"redis.googleapis.com/cluster/cpu/average_utilization\""
#      threshold_value = var.cpu_critical_threshold / 100
#      trigger {
#        count = 1
#      }
#    }
#  }
#
#  user_labels =  var.labels
#  severity = "CRITICAL"
#  documentation {
#    subject = "GCP Redis Cluster - ${var.cache_name} - CPU - CRITICAL"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_cluster.id)[3]};duration=PT1H?f.rlabel.cluster_id=${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_max_connections_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Cluster - Max Connections - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Cluster - Max Connections"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis.googleapis.com/Cluster\" AND resource.labels.cluster_id = \"${var.cache_name}\" AND metric.type = \"redis.googleapis.com/cluster/clients/total_connected_clients\""
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
#    subject = "GCP Redis Cluster - ${var.cache_name} - Max Connections - WARN"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_cluster.id)[3]};duration=PT1H?f.rlabel.cluster_id=${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_max_connections_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Cluster - Max Connections - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Cluster - Max Connections"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis.googleapis.com/Cluster\" AND resource.labels.cluster_id = \"${var.cache_name}\" AND metric.type = \"redis.googleapis.com/cluster/clients/total_connected_clients\""
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
#    subject = "GCP Redis Cluster - ${var.cache_name} - Max Connections - CRITICAL"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_cluster.id)[3]};duration=PT1H?f.rlabel.cluster_id=${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}

resource "google_monitoring_dashboard" "dashboard_redis_cluster" {
  project = var.gcp_project_id
  dashboard_json = <<EOF
  {
  "displayName": "Redis Cluster Dashboard - ${var.cache_name} - ${var.gcp_region}",
  "dashboardFilters": [
    {
      "filterType": "RESOURCE_LABEL",
      "labelKey": "cluster_id",
      "stringValue": "${var.cache_name}",
      "templateVariable": ""
    }
  ],
  "mosaicLayout": {
    "columns": 48,
    "tiles": [
      {
        "yPos": 64,
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
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/cpu/average_utilization\" resource.type=\"redis.googleapis.com/Cluster\""
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
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/commandstats/total_calls_count\" resource.type=\"redis.googleapis.com/Cluster\""
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
        "yPos": 48,
        "width": 24,
        "height": 16,
        "widget": {
          "title": "Hits/misses",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_keyspace_hits\" resource.type=\"redis.googleapis.com/Cluster\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_keyspace_misses\" resource.type=\"redis.googleapis.com/Cluster\""
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
                "filter": "metric.type=\"redis.googleapis.com/cluster/memory/average_utilization\" resource.type=\"redis.googleapis.com/Cluster\""
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
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/keyspace/total_keys\" resource.type=\"redis.googleapis.com/Cluster\""
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
        "height": 8,
        "widget": {
          "title": "Evictions",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_evicted_keys\" resource.type=\"redis.googleapis.com/Cluster\""
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
        "yPos": 40,
        "width": 24,
        "height": 8,
        "widget": {
          "title": "Expirations",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_expired_keys\" resource.type=\"redis.googleapis.com/Cluster\""
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
        "yPos": 80,
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
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_net_input_bytes_count\" resource.type=\"redis.googleapis.com/Cluster\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_net_output_bytes_count\" resource.type=\"redis.googleapis.com/Cluster\""
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
          "title": "Connected/Blocked Clients",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y2",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_connections_received_count\" resource.type=\"redis.googleapis.com/Cluster\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y2",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_rejected_connections_count\" resource.type=\"redis.googleapis.com/Cluster\""
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "y2Axis": {
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
          "title": "Commands Time",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/commandstats/total_usec_count\" resource.type=\"redis.googleapis.com/Cluster\""
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
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/memory/average_utilization\" resource.type=\"redis.googleapis.com/Cluster\""
                  }
                }
              }
            ],
            "thresholds": [],
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
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [],
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"redis.googleapis.com/cluster/memory/total_used_memory\" resource.type=\"redis.googleapis.com/Cluster\""
                  }
                }
              }
            ],
            "thresholds": [],
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
