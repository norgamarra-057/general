output "redis_instance_notification_channel_opsgenie" {
  value = "Created Opsgenie email notification channel ${google_monitoring_notification_channel.notification_channel.display_name}\ndestination: ${google_monitoring_notification_channel.notification_channel.labels.email_address}\nid: ${google_monitoring_notification_channel.notification_channel.id}"
}
