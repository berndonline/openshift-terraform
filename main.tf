# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}
# Declare the data source
data "aws_availability_zones" "available" {}
data "template_file" "sysprep-bastion" {
  template = "${file("./helper_scripts/sysprep-bastion.sh")}"
}
data "template_file" "sysprep-master" {
  template = "${file("./helper_scripts/sysprep-master.sh")}"
}
data "template_file" "sysprep-infra" {
  template = "${file("./helper_scripts/sysprep-infra.sh")}"
}
data "template_file" "sysprep-worker" {
  template = "${file("./helper_scripts/sysprep-worker.sh")}"
}
