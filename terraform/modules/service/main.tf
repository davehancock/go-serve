resource "aws_ecs_task_definition" "task-def" {
  family                = "go-serve-family"
  container_definitions = "${file("${path.module}/../../../aws_ecs_task_definitions.json")}"

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1]"
  }
}
