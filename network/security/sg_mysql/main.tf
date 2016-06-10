/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/s
variable "vpc_id" {}
variable "port" {default = 3306}
variable "incoming_cidr" {default = "0.0.0.0/0"}
variable "outgoing_cidr" {default = "0.0.0.0/0"}
variable "app_name" {default = ""}
variable "env" {default = ""}

/*--------------------------------------------------
 * Security Group
 *-------------------------------------------------*/
resource "aws_security_group" "mysql" {
  name = "mysql"
  description = "Security group for MySQL traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "${var.port}"
    to_port = "${var.port}"
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
  value = "${aws_security_group.mysql.id}"
}
