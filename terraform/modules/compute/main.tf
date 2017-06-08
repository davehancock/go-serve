resource "aws_instance" "node" {
  count = "${var.nodes}"
  key_name = "${var.key_name}"
  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.region}"
  instance_type = "${var.node_size}"
  vpc_security_group_ids = [
    "${var.security_group_ids}"]

  // TODO In a production environment it's more common to have a separate private subnet for backend instances.
  subnet_id = "${var.subnet_id}"
}
