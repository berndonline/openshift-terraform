# Create a VPC to launch our instances into
resource "google_compute_network" "vpc" {
 name                    = "vpc"
 auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "public" {
 name          = "public"
 ip_cidr_range = "${var.vpc_public}"
 network       = "vpc"
 depends_on    = ["google_compute_network.vpc"]
 region        = "${var.gcp_region}"
}
resource "google_compute_subnetwork" "private" {
 name          = "private"
 ip_cidr_range = "${var.vpc_private}"
 network       = "vpc"
 depends_on    = ["google_compute_network.vpc"]
 region        = "${var.gcp_region}"
}
resource "google_compute_router" "router" {
  name    = "router"
  region  = "${google_compute_subnetwork.private.region}"
  network = "${google_compute_network.vpc.self_link}"
}
resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = "${google_compute_router.router.name}"
  region                             = "${var.gcp_region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
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
      ports = ["22", "80", "443", "8443"]
  }
  source_ranges = ["0.0.0.0/0"]
}
