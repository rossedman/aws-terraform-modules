/*--------------------------------------------------
 * Load Balancer
 *-------------------------------------------------*/
resource "aws_elb" "web" {
  cross_zone_load_balancing = true
  subnets = ["${split(",", module.network.public_ids)}"]
  security_groups = ["${module.elb_security_group.id}"]

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 60
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}
