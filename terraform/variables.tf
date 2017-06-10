
variable "region" {
  default = "eu-west-1"
}

variable "ec2_region" {
  default = "eu-west-1c"
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

variable "key_name" {
  default = "dave-aws"
}

variable "node_size" {
  default = "t2.nano"
}

variable "nodes" {
  default = 3
}

variable "cluster_name" {
  default = "test-cluster"
}
