# Specify the provider and access details
provider "google" {
  credentials = "${file("./credentials.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}
# Declare the data source
data "template_file" "sysprep-bastion" {
  template = "${file("./helper_scripts/sysprep-bastion.sh")}"
}
data "template_file" "sysprep-openshift" {
  template = "${file("./helper_scripts/sysprep-openshift.sh")}"
}
terraform {
  backend "gcs" {
    bucket    = "techbloc-terraform-data"
    prefix    = "openshift-311"
  }
}
