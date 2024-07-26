#output "discovery_endpoints" {
#  description = "Endpoints created on each given network, for Redis clients to connect to the cluster. Currently only one endpoint is supported"
#  value       = google_redis_cluster.redis_cluster.discovery_endpoints
#}

output "redis_cluster_dns_name" {
  value = google_dns_record_set.dns.name
}

output "redis_cluster_dashboard" {
  value = "Created Redis Cluster Dashboard ${google_monitoring_dashboard.dashboard_redis_cluster.id}"
}