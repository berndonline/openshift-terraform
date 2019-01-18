# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}
# Declare the data source
data "aws_availability_zones" "available" {}
terraform {
  backend "s3" {
    bucket = "techbloc-terraform-data"
    key    = "openshift-311-aio"
    region = "eu-west-1"
  }
}
