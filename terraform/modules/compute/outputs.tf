output "instance_ids" {
  value = [
    "${aws_instance.node.id}"
  ]
}
