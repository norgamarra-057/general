output "cluster-endpoint" {
value = var.cluster_master_arn == "" ? aws_rds_cluster.master[0].endpoint : aws_rds_cluster.replica[0].endpoint
}

output "cluster-reader-endpoint" {
value = var.cluster_master_arn == "" ? aws_rds_cluster.master[0].reader_endpoint : aws_rds_cluster.replica[0].reader_endpoint
}

output "cluster-arn" {
value = var.cluster_master_arn == "" ? aws_rds_cluster.master[0].arn : aws_rds_cluster.replica[0].arn
}

output "cluster-rw-fqdn" {
value = (var.cname != null && var.cluster_master_arn == "") ? aws_route53_record.rw_cname[0].fqdn : ""
}

output "cluster-ro-fqdn" {
value = (var.cname != null && var.cluster_master_arn == "") ? aws_route53_record.ro_cname[0].fqdn : ""
}

output "cluster-ro-replica-fqdn" {
value = (var.cname != null && var.cluster_master_arn != "") ? aws_route53_record.ro_replica_cname[0].fqdn : ""
}
