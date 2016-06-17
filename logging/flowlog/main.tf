variable "name" {}
variable "eni_id" {default = ""}
variable "subnet_id" {default = ""}
variable "vpc_id" {default = ""}
variable "traffic_type" {default = "ALL"}

resource "aws_flow_log" "log" {
  log_group_name = "${var.name}"
  iam_role_arn = "${aws_iam_role.test_role.arn}"
  vpc_id = "${var.vpc_id}"
  traffic_type = "${var.traffic_type}"
}

resource "aws_iam_role" "flowlog_role" {
  name = "flowlog_role"
  assume_role_policy = "${file("./flowlog-role.json")}"
}

resource "aws_iam_role_policy" "flowlog_policy" {
  name = "flowlog_policy"
  role = "${aws_iam_role.test_role.id}"
  policy = "${file("./flowlog-policy.json")}"
}

output "id" {
  value = "${aws_flow_log.log.id}"
}
