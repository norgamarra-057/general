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
  zone_distribution_config {
    mode = "MULTI_ZONE"
  }

  deletion_protection_enabled = true
  
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
  "gridLayout": {
    "columns": "3",
    "widgets": [
      {
        "scorecard": {
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "filter": "metric.type=\"redis.googleapis.com/cluster/memory/average_utilization\" resource.type=\"redis.googleapis.com/Cluster\"",
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
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/memory/utilization\" resource.type=\"redis.googleapis.com/ClusterNode\"",
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
        "title": "Memory Usage (%)",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/memory/utilization\" resource.type=\"redis.googleapis.com/ClusterNode\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MAX",
                    "crossSeriesReducer": "REDUCE_MAX",
                    "groupByFields": [
                      "resource.label.\"node_id\""
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
        "title": "Memory Usage (%) per Node",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/commandstats/calls_count\" resource.type=\"redis.googleapis.com/ClusterNode\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
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
        "title": "Commands Count",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/keyspace/total_keys\" resource.type=\"redis.googleapis.com/ClusterNode\"",
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
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/stats/expired_keys_count\" resource.type=\"redis.googleapis.com/ClusterNode\"",
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
              "targetAxis": "Y2",
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
          "y2Axis": {
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
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/memory/usage\" resource.type=\"redis.googleapis.com/ClusterNode\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_MEAN",
                    "groupByFields": [
                      "resource.label.\"node_id\""
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
        "title": "Memory Usage all nodes",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/commandstats/total_usec_count\" resource.type=\"redis.googleapis.com/Cluster\"",
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
        "title": "Commands Time",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_keyspace_hits\" resource.type=\"redis.googleapis.com/Cluster\"",
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
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_keyspace_misses\" resource.type=\"redis.googleapis.com/Cluster\"",
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
        "title": "Hits/misses",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/keyspace/total_keys\" resource.type=\"redis.googleapis.com/ClusterNode\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN",
                    "crossSeriesReducer": "REDUCE_MEAN",
                    "groupByFields": [
                      "resource.label.\"shard_id\""
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
            },
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/stats/expired_keys_count\" resource.type=\"redis.googleapis.com/ClusterNode\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE",
                    "crossSeriesReducer": "REDUCE_MEAN",
                    "groupByFields": [
                      "resource.label.\"shard_id\""
                    ]
                  }
                },
                "unitOverride": "",
                "outputFullDuration": false
              },
              "plotType": "LINE",
              "legendTemplate": "",
              "minAlignmentPeriod": "60s",
              "targetAxis": "Y2",
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
          "y2Axis": {
            "label": "",
            "scale": "LINEAR"
          },
          "chartOptions": {
            "mode": "COLOR",
            "showLegend": false,
            "displayHorizontal": false
          }
        },
        "title": "Keys all nodes",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_expired_keys\" resource.type=\"redis.googleapis.com/Cluster\"",
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
        "title": "Expirations",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_connections_received_count\" resource.type=\"redis.googleapis.com/Cluster\"",
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
              "targetAxis": "Y2",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            },
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_rejected_connections_count\" resource.type=\"redis.googleapis.com/Cluster\"",
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
              "targetAxis": "Y2",
              "dimensions": [],
              "measures": [],
              "breakdowns": []
            }
          ],
          "timeshiftDuration": "0s",
          "thresholds": [],
          "y2Axis": {
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
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/cpu/utilization\" resource.type=\"redis.googleapis.com/ClusterNode\"",
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
        "title": "CPU Usage",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/average_evicted_keys\" resource.type=\"redis.googleapis.com/Cluster\"",
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
        "title": "Evictions",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/node/clients/connected_clients\" resource.type=\"redis.googleapis.com/ClusterNode\"",
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
        "title": "Clients connections",
        "id": ""
      },
      {
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_net_input_bytes_count\" resource.type=\"redis.googleapis.com/Cluster\"",
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
                  "filter": "metric.type=\"redis.googleapis.com/cluster/stats/total_net_output_bytes_count\" resource.type=\"redis.googleapis.com/Cluster\"",
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
      }
    ]
  },
  "labels": {${join(",", [for key, value in var.labels : "\"${key}\":\"${value}\""])}}
}

  EOF
}