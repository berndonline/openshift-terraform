provider "google" {
  credentials = "${file("./credentials.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}
terraform {
  backend "gcs" {
    bucket    = "techbloc-terraform-data"
    prefix    = "openshift-311"
    credentials = "credentials.json"
  }
}
data "template_file" "sysprep-bastion" {
  template = "${file("./helper_scripts/sysprep-bastion.sh")}"
}
