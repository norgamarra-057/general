output "master-endpoint" {
value =  aws_db_instance.master.endpoint
}

output "replica-endpoint" {
value =  aws_db_instance.replicas.*.endpoint
}

output "cluster-rw-fqdn" {
value = (var.cname != null && var.replicate_source_db == "") ? aws_route53_record.rw_cname[0].fqdn : ""
}
output "cluster-ro-fqdn" {
value = (var.cname != null && var.replicate_source_db == "" && var.local_replica_cnt > 0) ? aws_route53_record.ro_cname[0].fqdn : ""
}
output "cluster-replica-fqdn" {
value = (var.cname != null && var.replicate_source_db != "") ? aws_route53_record.replica_cname[0].fqdn : ""
}
