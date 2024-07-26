output "redis_instance_dns_name" {
  value = google_dns_record_set.dns.name
}

#output "redis_instance_alert_policy_oom_warning" {
#  value = "Created Alert Policy ${google_monitoring_alert_policy.alert_policy_oom_warning.display_name}\nid:${google_monitoring_alert_policy.alert_policy_oom_warning.id}\nnotification channel: ${google_monitoring_alert_policy.alert_policy_oom_warning.notification_channels[0]}"
#}
#
#output "redis_instance_alert_policy_oom_critical" {
#  value = "Created Alert Policy ${google_monitoring_alert_policy.alert_policy_oom_critical.display_name}\nid:${google_monitoring_alert_policy.alert_policy_oom_critical.id}\nnotification channel: ${google_monitoring_alert_policy.alert_policy_oom_critical.notification_channels[0]}"
#}
#
#output "redis_instance_alert_policy_cpu_warning" {
#  value = "Created Alert Policy ${google_monitoring_alert_policy.alert_policy_cpu_warning.display_name}\nid:${google_monitoring_alert_policy.alert_policy_cpu_warning.id}\nnotification channel: ${google_monitoring_alert_policy.alert_policy_cpu_warning.notification_channels[0]}"
#}
#
#output "redis_instance_alert_policy_cpu_critical" {
#  value = "Created Alert Policy ${google_monitoring_alert_policy.alert_policy_cpu_critical.display_name}\nid:${google_monitoring_alert_policy.alert_policy_cpu_critical.id}\nnotification channel: ${google_monitoring_alert_policy.alert_policy_cpu_critical.notification_channels[0]}"
#}
#
#output "redis_instance_alert_policy_max_connections_warning" {
#  value = "Created Alert Policy ${google_monitoring_alert_policy.alert_policy_max_connections_warning.display_name}\nid:${google_monitoring_alert_policy.alert_policy_max_connections_warning.id}\nnotification channel: ${google_monitoring_alert_policy.alert_policy_max_connections_warning.notification_channels[0]}"
#}
#
#output "redis_instance_alert_policy_max_connections_critical" {
#  value = "Created Alert Policy ${google_monitoring_alert_policy.alert_policy_max_connections_critical.display_name}\nid: ${google_monitoring_alert_policy.alert_policy_max_connections_critical.id}\nnotification channel: ${google_monitoring_alert_policy.alert_policy_max_connections_critical.notification_channels[0]}"
#}

output "redis_instance_dashboard" {
  value = "Created Redis Instance Dashboard ${google_monitoring_dashboard.dashboard_redis_instance.id}"
}