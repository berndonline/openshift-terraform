# Create a VPC to launch our instances into
resource "google_compute_network" "vpc" {
 name                    = "VPC"
 auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "subnet" {
 name          = "Public Subnet A"
 ip_cidr_range = "${var.public_subnet_a}"
 network       = "VPC"
 depends_on    = ["google_compute_network.vpc"]
 region        = "${var.gcp_region}"
}
resource "google_compute_firewall" "firewall" {
  name    = "vpc-firewall"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
