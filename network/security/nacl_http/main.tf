variable "name" {default = "http-nacl"}
variable "app_name" {}
variable "environment" {}
variable "http_cidr_block" {default = "0.0.0.0/0"}
variable "ssh_cidr_block" {default = "0.0.0.0/0"}
variable "vpc_id" {}

resource "aws_network_acl" "http" {
  vpc_id = "${var.vpc_id}"

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
    cidr_block = "0.0.0."
    from_port = 1024
    to_port = 65535
  }

  egress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.http_cidr_block}"
    from_port = 80
    to_port = 80
  }

  egress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "${var.http_cidr_block}"
    from_port = 443
    to_port = 443
  }

  egress {
    protocol = "tcp"
    rule_no = 300
    action = "allow"
    cidr_block = "${var.http_cidr_block}"
    from_port = 22
    to_port = 22
  }

  egress {
    protocol = "tcp"
    rule_no = 400
    action = "allow"
    cidr_block = "${var.http_cidr_block}"
    from_port = 1024
    to_port = 65535
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
