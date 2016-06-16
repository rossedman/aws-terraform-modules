/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "vpc_id" {}
variable "incoming_cidr" {default = "0.0.0.0/0"}
variable "outgoing_cidr" {default = "0.0.0.0/0"}
variable "app_name" {default = ""}
variable "environment" {default = ""}
variable "name" {}

/*--------------------------------------------------
 * Security Group
 *-------------------------------------------------*/
resource "aws_security_group" "elastic" {
  name = "${var.name}"
  description = "Security group for elasticsearch"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 9300
    to_port = 9400
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.incoming_cidr)}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${split(",", var.outgoing_cidr)}"]
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Output
 *-------------------------------------------------*/
output "id" {
  value = "${aws_security_group.web.id}"
}
