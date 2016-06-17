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
resource "aws_security_group" "web" {
  name = "${var.name}"
  description = "Security group for HTTP/HTTPS web traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
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
