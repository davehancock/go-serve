provider "aws" {
  region = "${var.region}"
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
}

module "network" {
  source = "./modules/network"
  region = "${var.region}"
  availabilty_zones = "${var.availabilty_zones}"
  cidr_block = "${var.cidr_block}"
}
