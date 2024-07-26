
#output "subnet_group_id" {
#  value       = "${join("", aws_db_subnet_group.default.*.id)}"
#  description = "ID of the Subnet Group"
#}

#output "subnet_group_name" {
#  value       = "${join("", aws_db_subnet_group.default.*.name)}"
#  description = "Name of the Subnet Group"
#}
