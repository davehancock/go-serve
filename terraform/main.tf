provider "aws" {
  region = "${var.region}"
}

module "compute" {
  source = "./modules/compute"
  amis = "${var.amis}"
  region = "${var.ec2_region}"
  nodes = "${var.nodes}"
  node_size = "${var.node_size}"
  key_name = "${var.key_name}"
  subnet_id = "${module.network.subnet_id}"
  security_group_ids = "${module.network.security_group_ids}"
}

module "network" {
  source = "./modules/network"
  region = "${var.ec2_region}"
  instance_ids = "${module.compute.instance_ids}"
  hosted_zone_id = "${var.hosted_zone_id}"
}

module "task" {
  source = "./modules/task"
}
