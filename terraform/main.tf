provider "aws" {
  region = "${var.region}"
}

module "iam" {
  source = "./modules/iam"
}

module "compute" {
  source = "./modules/compute"
  region = "${var.region}"
  availabilty_zones = "${var.availabilty_zones}"
  amis = "${var.amis}"
  min_nodes = "${var.min_nodes}"
  max_nodes = "${var.max_nodes}"
  node_size = "${var.node_size}"
  ssh_key_name = "${var.ssh_key_name}"
  vpc_subnet_ids = "${module.network.vpc_subnet_ids}"
  security_group_ids = "${module.network.security_group_ids}"
  cluster_name = "${var.cluster_name}"
  ec2_iam_profile_id = "${module.iam.ec2_iam_profile_id}"
}

module "network" {
  source = "./modules/network"
  region = "${var.region}"
  availabilty_zones = "${var.availabilty_zones}"
  cidr_block = "${var.cidr_block}"
}
