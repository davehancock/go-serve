resource "aws_ecs_task_definition" "task-definition" {
  family                = "go-serve-family"
  container_definitions = "${file("${path.module}/../../../aws_ecs_task_definitions.json")}"
}
