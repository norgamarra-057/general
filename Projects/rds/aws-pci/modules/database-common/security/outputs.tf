
#output "security_group_id" {
#  value       = "${join("", aws_security_group.default.*.id)}"
#  description = "ID of the Security Group"
#}
