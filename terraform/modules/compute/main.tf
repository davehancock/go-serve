resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}"
}

// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
resource "aws_launch_configuration" "ecs" {
  name = "ecs_lc"
  key_name = "${var.ssh_key_name}"
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "${var.node_size}"
  security_groups = [
    "${var.security_group_ids}"
  ]
  iam_instance_profile = "${aws_iam_instance_profile.ec2_iam_profile.id}"
  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} > /etc/ecs/ecs.config"
}

resource "aws_autoscaling_group" "ecs" {
  name = "ecs_asg"
  availability_zones = [
    "${split(",", lookup(var.availabilty_zones, var.region))}"
  ]
  vpc_zone_identifier = [
    "${var.vpc_subnet_ids}"
  ]
  launch_configuration = "${aws_launch_configuration.ecs.id}"
  min_size = "${var.min_nodes}"
  max_size = "${var.max_nodes}"
  desired_capacity = "${var.min_nodes}"
}


resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "ec2_instance_profile"
  role = "${aws_iam_role.ec2_iam_role.id}"
}


// The role / policy to allow ec2 to install and interact with the ecs agent to form the cluster
// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
resource "aws_iam_role_policy" "ec2_iam_role_policy" {
  name = "ec2_instance_role"
  role = "${aws_iam_role.ec2_iam_role.id}"
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


resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2_iam"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
]
}
EOF
}


// The role / policy used to allow ECS to register services with an ALB etc
resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "ecs_service_policy"
  role = "${aws_iam_role.ecs_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
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
