output "security_group_ids" {
  value = [
    "${aws_security_group.ec2_default.id}"
  ]
}

output "vpc_subnet_ids" {
  value = "${aws_subnet.ecs_subnet.*.id}"
}
