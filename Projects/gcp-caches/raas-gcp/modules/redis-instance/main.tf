resource "google_redis_instance" "redis-instance" {
  name    = var.cache_name
  region  = var.gcp_region
  project = var.gcp_project_id
  tier    = var.service_tier  
  redis_version = var.redis_version
  display_name  = var.cache_display_name
  replica_count = var.read_replicas_mode == "READ_REPLICAS_ENABLED" ? var.replica_count : var.replica_count  
  read_replicas_mode = var.read_replicas_mode
  

  authorized_network = data.google_compute_network.redis_network.id

  # This is needed to setup the authorized network.  Otherwise direct peering
  # is used.
  connect_mode = "PRIVATE_SERVICE_ACCESS"

  maintenance_policy {
    weekly_maintenance_window {
      day = "TUESDAY"
      start_time {
        hours = 07
        minutes = 00
      }
    }
  }

  labels = var.labels
  
  
  persistence_config {
    persistence_mode = "RDB"
    rdb_snapshot_period = "TWENTY_FOUR_HOURS"
    rdb_snapshot_start_time = "2024-01-01T07:00:00Z"
  }
  memory_size_gb = var.memory_size
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

  rrdatas = [google_redis_instance.redis-instance.host]
}

#data "google_monitoring_notification_channel" "email_opsgenie" {
#  project = var.gcp_project_id
#  display_name = "RaaS Team Opsgenie"
#  type = "email"
#}

#data "google_monitoring_notification_channel" "email_raas" {
#  project = var.gcp_project_id
#  display_name = "RaaS Team Email"
#  type = "email"
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_oom_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Instance - OOM - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Instance - OOM"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis_instance\" AND resource.label.\"instance_id\" = \"${google_redis_instance.redis-instance.id}\" AND metric.type = \"redis.googleapis.com/stats/memory/usage_ratio\""
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
#    subject = "GCP Redis Instance - ${var.cache_name} - OOM - WARN"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_oom_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Instance - OOM - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Instance - OOM"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis_instance\" AND resource.label.\"instance_id\" = \"${google_redis_instance.redis-instance.id}\" AND metric.type = \"redis.googleapis.com/stats/memory/usage_ratio\""
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
#    subject = "GCP Redis Instance - ${var.cache_name} - OOM - CRITICAL"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#
#
#
#
#resource "google_monitoring_alert_policy" "alert_policy_cpu_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Instance - CPU - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Instance - CPU"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis_instance\" AND resource.label.\"instance_id\" = \"${google_redis_instance.redis-instance.id}\" AND metric.type = \"redis.googleapis.com/stats/cpu_utilization\""
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
#    subject = "GCP Redis Instance - ${var.cache_name} - CPU - WARN"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_cpu_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Instance - CPU - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Instance - CPU"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis_instance\" AND resource.label.\"instance_id\" = \"${google_redis_instance.redis-instance.id}\" AND metric.type = \"redis.googleapis.com/stats/cpu_utilization\""
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
#    subject = "GCP Redis Instance - ${var.cache_name} - CPU - CRITICAL"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#
#
#
#resource "google_monitoring_alert_policy" "alert_policy_max_connections_warning" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Instance - Max Connections - WARN"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_raas.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Instance - Max Connections"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis_instance\" AND resource.label.\"instance_id\" = \"${google_redis_instance.redis-instance.id}\" AND metric.type = \"redis.googleapis.com/stats/connections/total\""
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
#    subject = "GCP Redis Instance - ${var.cache_name} - Max Connections - WARN"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}
#
#resource "google_monitoring_alert_policy" "alert_policy_max_connections_critical" {
#  project = var.gcp_project_id
#  display_name = "${var.cache_name} - Redis Instance - Max Connections - CRITICAL"
#  combiner     = "OR"
#  notification_channels = [data.google_monitoring_notification_channel.email_opsgenie.id]
#  conditions {
#    display_name = "Cloud Memorystore Redis Instance - Max Connections"
#    condition_threshold {
#      aggregations {
#        alignment_period   = "300s"
#        per_series_aligner = "ALIGN_MEAN"
#      }
#      comparison = "COMPARISON_GT"
#      duration   = "60s"
#      filter     = "resource.type = \"redis_instance\" AND resource.label.\"instance_id\" = \"${google_redis_instance.redis-instance.id}\" AND metric.type = \"redis.googleapis.com/stats/connections/total\""
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
#    subject = "GCP Redis Instance - ${var.cache_name} - Max Connections - CRITICAL"
#    mime_type = "text/markdown"
#    content = "Dashboard URL: https://console.cloud.google.com/monitoring/dashboards/builder/${split("/",google_monitoring_dashboard.dashboard_redis_instance.id)[3]};duration=PT1H?f.rlabel.instance_id=projects%2F${var.gcp_project_id}%2Flocations%2F${var.gcp_region}%2Finstances%2F${var.cache_name}&project=${var.gcp_project_id}"
#  }
#}


resource "google_monitoring_dashboard" "dashboard_redis_instance" {
  project = var.gcp_project_id
  dashboard_json = <<EOF
  {
  "displayName": "Redis Instance Dashboard - ${var.cache_name} - ${var.gcp_region}",
  "dashboardFilters": [
    {
      "filterType": "RESOURCE_LABEL",
      "labelKey": "instance_id",
      "stringValue": "${google_redis_instance.redis-instance.id}",
      "templateVariable": ""
    }
  ],
  "gridLayout": {
    "columns": "3",
    "widgets": [
      {
        "scorecard": {
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "filter": "metric.type=\"redis.googleapis.com/stats/memory/usage_ratio\" resource.type=\"redis_instance\"",
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_MEAN",
                "crossSeriesReducer": "REDUCE_MEAN",
                "groupByFields": []
              }
            },
            "unitOverride": "",
            "outputFullDuration": false
          },
          "gaugeView": {
            "lowerBound": 0,
            "upperBound": 1
          },
          "thresholds": [
            {
              "label": "",
              "value": 0.8,
              "color": "YELLOW",
              "direction": "ABOVE",
              "targetAxis": "TARGET_AXIS_UNSPECIFIED"
            },
            {
              "label": "",
              "value": 0.9,
              "color": "RED",
              "direction": "ABOVE",
              "targetAxis": "TARGET_AXIS_UNSPECIFIED"
            }
          ],
          "dimensions": [],
          "measures": []
        },
        "title": "Memory Usage Ratio",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilterRatio": {
                  "numerator": {
                    "filter": "metric.type=\"redis.googleapis.com/stats/memory/usage\" resource.type=\"redis_instance\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [
                        "resource.label.\"instance_id\""
                      ]
                    }
                  },
                  "denominator": {
                    "filter": "metric.type=\"redis.googleapis.com/stats/memory/maxmemory\" resource.type=\"redis_instance\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MAX",
                      "groupByFields": [
                        "resource.label.\"instance_id\""
                      ]
                    }
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Memory Usage (%)",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/memory/usage\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Memory Usage",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/commands/calls\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": [
                      "metric.label.\"cmd\""
                    ]
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Commands (all)",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/keyspace/keys\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Keys",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/keyspace_hits\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            },
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/keyspace_misses\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Hits/misses",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/expired_keys\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Expirations",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/evicted_keys\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Evictions",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilterRatio": {
                  "numerator": {
                    "filter": "metric.type=\"redis.googleapis.com/stats/cpu_utilization\" resource.type=\"redis_instance\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE",
                      "crossSeriesReducer": "REDUCE_MIN",
                      "groupByFields": [
                        "resource.label.\"instance_id\""
                      ]
                    }
                  },
                  "denominator": {
                    "filter": "metric.type=\"redis.googleapis.com/stats/cpu_utilization\" resource.type=\"redis_instance\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_RATE",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [
                        "resource.label.\"instance_id\""
                      ]
                    }
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "CPU Usage",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/keyspace/keys_with_expiration\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Keys with TTL",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/cache_hit_ratio\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Hit Ratio",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/clients/connected\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            },
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/clients/blocked\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Connected/Blocked Clients",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/keyspace/avg_ttl\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Average TTL",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/commands/usec_per_call\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": [
                      "metric.label.\"cmd\""
                    ]
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Time per Call",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/server/uptime\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Uptime",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/stats/network_traffic\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Network Traffic",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/clients/connected\" resource.type=\"redis_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "groupByFields": []
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y1",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "yAxis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Clients",
        "id": ""
      }
    ]
  },
  "labels": {${join(",", [for key, value in var.labels : "\"${key}\":\"${value}\""])}}
}

  EOF
}
