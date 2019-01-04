# Specify the provider and access details
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
