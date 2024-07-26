resource "google_monitoring_notification_channel" "notification_channel" {
  project = var.gcp_project_id
  display_name = var.channel_name
  type = var.channel_type
  labels = {
    email_address = var.channel_address
  }
}
