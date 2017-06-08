output "instance_ids" {
  value = [
    "${aws_instance.ecs_node.id}"
  ]
}
