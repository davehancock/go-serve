// TODO Extract some values out of here
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "test-ecs-cluster"
}


// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
resource "aws_instance" "ecs_node" {
  count = "${var.nodes}"
  key_name = "${var.key_name}"
  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.region}"
  instance_type = "${var.node_size}"
  vpc_security_group_ids = [
    "${var.security_group_ids}"]
  subnet_id = "${var.subnet_id}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_profile.name}"
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
EOF
}


resource "aws_iam_instance_profile" "ecs_iam_profile" {
  name = "ecs_instance_role"
  role = "${aws_iam_role.ecs_iam_role.name}"
}


// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
resource "aws_iam_role_policy" "ecs_iam_role_policy" {
  name = "ecs_instance_role"
  role = "${aws_iam_role.ecs_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:UpdateContainerInstancesState",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role" "ecs_iam_role" {
  name = "ecs_iam"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "ecs.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
]
}
EOF
}
