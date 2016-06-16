/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "agent_version" {default = "LATEST"}
variable "cookbook_bucket" {}
variable "chef_version" {default = "12"}
variable "default_os" {default = "Amazon Linux 2016.03"}
variable "default_subnet_id" {}
variable "default_ssh_key_name" {}
variable "use_opsworks_sgs" {default = false}
variable "region" {}
variable "stack_name" {}
variable "vpc_id" {}

/*--------------------------------------------------
 * Opsworks
 *
 * This is meant for using Chef 12 with custom cookbooks
 * that means some of these values are hardcoded for that
 *-------------------------------------------------*/

 # give opsworks the ability to work with ec2 instances as
 # well as s3 and opsworks.
 resource "aws_iam_role" "opsworks" {
   name = "opsworks_role"
   assume_role_policy = "${file("${path.module}/opsworks-role.json")}"
 }

 resource "aws_iam_role_policy" "opsworks" {
   name = "opsworks_role_policy"
   role = "${aws_iam_role.opsworks.id}"
   policy = "${file("${path.module}/opsworks-policy.json")}"
 }

 # create role and attach policy. this will be provided
 # to new instances in the stack.
 resource "aws_iam_role" "opsworks_instances" {
   name = "opsworks_instance_role"
   assume_role_policy = "${file("${path.module}/opsworks-instance-role.json")}"
 }

 resource "aws_iam_role_policy" "opsworks_instances" {
   name = "opsworks_instance_policy"
   role = "${aws_iam_role.opsworks_instances.id}"
   policy = "${file("${path.module}/opsworks-instance-policy.json")}"
 }

 resource "aws_iam_instance_profile" "opsworks" {
   name = "opsworks_instances"
   roles = ["${aws_iam_role.opsworks_instances.name}"]
 }

 # create the stack
 resource "aws_opsworks_stack" "main" {
   name = "${var.stack_name}"
   region = "${var.region}"
   default_os = "${var.default_os}"
   agent_version = "${var.agent_version}"
   service_role_arn = "${aws_iam_role.opsworks.arn}"
   default_instance_profile_arn = "${aws_iam_instance_profile.opsworks.arn}"
   configuration_manager_version = "${var.chef_version}"
   vpc_id = "${var.vpc_id}"
   default_subnet_id = "${var.default_subnet_id}"
   default_ssh_key_name = "${var.default_ssh_key_name}"
   use_opsworks_security_groups = false
   use_custom_cookbooks = true

   custom_cookbooks_source {
     type = "s3"
     url = "${var.cookbook_bucket}"
   }
 }

/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
output "id" {
  value = "${aws_opsworks_stack.main.id}"
}
