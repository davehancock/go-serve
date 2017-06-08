output "security_group_ids" {
  value = [
    "${aws_security_group.ec2_default.id}"
  ]
}

output "subnet_id" {
  value = "${aws_subnet.default.id}"
}
