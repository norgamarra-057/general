output "instances" {
  value = aws_instance.ec2.*.id
}

output "arn" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.arn)
}

output "availability_zone" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.availability_zone)
}

output "placement_group" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.placement_group)
}

output "key_name" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.key_name)
}

output "password_data" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.password_data)
}

output "public_dns" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.public_dns)
}

output "public_ip" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.public_ip)
}

output "ipv6_addresses" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.ipv6_addresses)
}

#output "network_interface_id" {
#  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.network_interface_id)
#}

output "primary_network_interface_id" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.primary_network_interface_id)
}

output "private_dns" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.private_dns)
}

output "private_ip" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.private_ip)
}

output "security_groups" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.security_groups)
}

output "vpc_security_group_ids" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.vpc_security_group_ids)
}

output "subnet_id" {
  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.subnet_id)
}

// disabled. seems to fail on initial plan/apply. only passes after resource has bee created...
// * output.credit_specification: Resource 'aws_instance.ec2' does not have attribute 'credit_specification' for variable 'aws_instance.ec2.*.credit_specification'
//output "credit_specification" {
//  value = zipmap(aws_instance.ec2.*.id, aws_instance.ec2.*.credit_specification)
//}
