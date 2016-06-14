/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "vpc_id" {}
variable "incoming_cidr" {default = "0.0.0.0/0"}
variable "outgoing_cidr" {default = "0.0.0.0/0"}
variable "app_name" {default = ""}
variable "environment" {default = ""}

/*--------------------------------------------------
 * Security Group
 *-------------------------------------------------*/
resource "aws_security_group" "web" {
  name = "web"
  description = "Security group for HTTP/HTTPS web traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.incoming_cidr)}"]
  }

  ingress {
    from_port = 443
    to_port = 443
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
  value = "${aws_security_group.http.id}"
}
