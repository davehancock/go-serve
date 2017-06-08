
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

variable "hosted_zone_id" {
  default = "Z191JAX47C5HSH"
}

variable "node_size" {
  default = "t2.small"
}

variable "nodes" {
  default = 3
}