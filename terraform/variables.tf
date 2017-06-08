
variable "region" {
  default = "eu-west-1"
}

variable "ec2_region" {
  default = "eu-west-1c"
}

variable "amis" {
  type = "map"
  default = {
    // EU West-1 CoreOS Alpha HVM Image
    eu-west-1 = "ami-f44f1592"
    eu-west-1a = "ami-f44f1592"
    eu-west-1b = "ami-f44f1592"
    eu-west-1c = "ami-f44f1592"
  }
}

// TODO Use OTF keys
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