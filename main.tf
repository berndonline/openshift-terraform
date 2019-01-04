# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}
# Declare the data source
data "aws_availability_zones" "available" {}
data "template_file" "sysprep-bastion" {
  template = "${file("./helper_scripts/sysprep-bastion.sh")}"
}
terraform {
  backend "s3" {
    bucket = "techbloc-terraform-data"
    key    = "openshift-311"
    region = "eu-west-1"
  }
}
