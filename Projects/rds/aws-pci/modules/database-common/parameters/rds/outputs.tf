
#output "parameter_group_id" {
#  value       = "${join("", aws_db_parameter_group.default.*.id)}"
#  description = "ID of the Parameter Group"
#}

#output "parameter_group_name" {
#  value       = "${join("", aws_db_parameter_group.default.*.name)}"
#  description = "Name of the Parameter Group"
#}
