
output "option_group_id" {
  value       = "${join("", aws_db_option_group.default.*.id)}"
  description = "ID of the Option Group"
}


output "option_group_name" {
  value       = "${join("", aws_db_option_group.default.*.name)}"
  description = "Name of the Option Group"
}
