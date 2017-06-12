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
  iam_instance_profile = "${var.ec2_iam_profile_id}"
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
