variable "name" {default = "http-nacl"}
variable "app_name" {}
variable "environment" {}
variable "egress_cidr_block" {default = "0.0.0.0/0"}
variable "ephemeral_cidr_block" {default = "0.0.0.0/0"}
variable "http_cidr_block" {default = "0.0.0.0/0"}
variable "ssh_cidr_block" {default = "0.0.0.0/0"}
variable "subnet_ids" {}
variable "vpc_id" {}

resource "aws_network_acl" "http" {
  vpc_id = "${var.vpc_id}"
  subnet_ids = ["${split(",", var.subnet_ids)}"]

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.http_cidr_block}"
    from_port = 80
    to_port = 80
  }

  ingress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "${var.http_cidr_block}"
    from_port = 443
    to_port = 443
  }

  ingress {
    protocol = "tcp"
    rule_no = 300
    action = "allow"
    cidr_block = "${var.ssh_cidr_block}"
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    rule_no = 400
    action = "allow"
    cidr_block = "${var.ephemeral_cidr_block}"
    from_port = 1024
    to_port = 65535
  }

  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "${var.egress_cidr_block}"
    from_port = 0
    to_port = 0
  }

  tags {
    Name = "${var.name}"
    App = "${var.app_name}"
    Env = "${var.environment}"
  }
}

output "id" {
  value = "${aws_network_acl.http.id}"
}
