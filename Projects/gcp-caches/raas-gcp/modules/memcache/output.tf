output "memcache_instance_dns_name" {
  value = google_dns_record_set.dns.name
}

#output "redis_instance_dashboard" {
#  value = "Created Memcache Dashboard ${google_monitoring_dashboard.dashboard_memcache.id}"
#}