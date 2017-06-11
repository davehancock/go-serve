variable "region" {
}

variable "availabilty_zones" {
  type = "map"
}

variable "amis" {
  type = "map"
}

variable "ssh_key_name" {
}

variable "security_group_ids" {
  type = "list"
}

variable "vpc_subnet_ids" {
  type = "list"
}

variable "node_size" {
}

variable "min_nodes" {
}

variable "max_nodes" {
}

variable "cluster_name" {
}
