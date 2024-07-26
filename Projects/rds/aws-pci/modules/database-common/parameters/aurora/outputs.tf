
#output "" {
#  value       = "${join("", aws_db_parameter_group.default.*.id)}"
#}

#output "parameter_group_name" {
#  value       = "${join("", aws_db_parameter_group.default.*.name)}"
#}

output "cpg-small" {
value =  aws_rds_cluster_parameter_group.cpg-small.name
}

output "cpg-medium" {
value =  aws_rds_cluster_parameter_group.cpg-medium.name
}

output "cpg-medium-nobinlog" {
value =  aws_rds_cluster_parameter_group.cpg-medium-nobinlog.name
}

output "cpg-large" {
value =  aws_rds_cluster_parameter_group.cpg-large.name
}

output "ipg-small" {
value =  aws_db_parameter_group.ipg-small.name
}

output "ipg-medium" {
value =  aws_db_parameter_group.ipg-medium.name
}

output "ipg-medium-nobinlog" {
value =  aws_db_parameter_group.ipg-medium-nobinlog.name
}

output "ipg-large" {
value =  aws_db_parameter_group.ipg-large.name
}
