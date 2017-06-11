variable "region" {
  default = "eu-west-1"
}

variable "amis" {
  type = "map"
  default = {
    // EU West-1 ECS Optimizied AMI
    eu-west-1 = "ami-a1e6f5c7"
    eu-west-1a = "ami-a1e6f5c7"
    eu-west-1b = "ami-a1e6f5c7"
    eu-west-1c = "ami-a1e6f5c7"
  }
}

variable "availabilty_zones" {
  type = "map"
  default = {
    "eu-west-1" = "eu-west-1a,eu-west-1b,eu-west-1c"
  }
}

variable "ssh_key_name" {
  default = "dave-aws"
}

variable "node_size" {
  default = "t2.nano"
}

variable "min_nodes" {
  default = 3
}

variable "max_nodes" {
  default = 5
}

variable "cluster_name" {
  default = "test-cluster"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}
