# Create a VPC to launch our instances into
resource "google_compute_network" "vpc" {
 name                    = "vpc"
 auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "subnet" {
 name          = "subnet"
 ip_cidr_range = "${var.vpc_cidr}"
 network       = "vpc"
 depends_on    = ["google_compute_network.vpc"]
 region        = "${var.gcp_region}"
}
resource "google_compute_firewall" "firewall-internal" {
  name    = "vpc-firewall-internal"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "all"
  }
  source_ranges = ["10.0.0.0/20"]
}
resource "google_compute_firewall" "firewall-external" {
  name    = "vpc-firewall-external"
  network = "${google_compute_network.vpc.name}"
  allow {
      protocol = "tcp"
      ports = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}
