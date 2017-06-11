// Create a VPC to launch our instances into
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "${var.cidr_block}"
}

// Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.ecs_vpc.id}"
}

// Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.ecs_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

// Create a subnet per AZ to launch our instances into (ALB requires at least 2, plus the more the better for high availability...)
resource "aws_subnet" "ecs_subnet" {
  vpc_id = "${aws_vpc.ecs_vpc.id}"
  count = "${length(split(",", lookup(var.availabilty_zones, var.region)))}"
  availability_zone = "${element(split(",", lookup(var.availabilty_zones, var.region)), count.index)}"
  cidr_block = "${cidrsubnet(var.cidr_block, 4, count.index)}"
  map_public_ip_on_launch = true
}

// A security group for the ALB so it is accessible via the web
resource "aws_security_group" "alb" {

  name = "alb-security-group"
  vpc_id = "${aws_vpc.ecs_vpc.id}"
  description = "ALB specific group"

  // HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

// Our default security group to access the instances over SSH and HTTP
resource "aws_security_group" "ec2_default" {

  name = "ec2-security-group"
  vpc_id = "${aws_vpc.ecs_vpc.id}"
  description = "Default group for any EC2 instance"

  // SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  // HTTP access from the VPC
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_block}"
    ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_block}"
    ]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}


// Create Application Load Balancer for external access to the VPC and internal routing to services using dynamic port allocation
resource "aws_alb" "ecs_alb" {

  name = "ecs-alb"

  subnets = [
    "${aws_subnet.ecs_subnet.*.id}"
  ]
  security_groups = [
    "${aws_security_group.alb.id}"
  ]
}

resource "aws_alb_target_group" "ecs_alb_tg" {
  name     = "ecs-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.ecs_vpc.id}"
}


resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.ecs_alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs_alb_tg.id}"
    type             = "forward"
  }
}
