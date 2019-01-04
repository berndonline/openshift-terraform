resource "google_compute_address" "infra" {
    name = "infra-address"
}
resource "google_compute_target_pool" "infra" {
  name = "infra-target-pool"
  instances = ["${google_compute_instance.infra1.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.http.name}"]
}
resource "google_compute_forwarding_rule" "http-infra" {
  name = "infra-www-http-forwarding-rule"
  target = "${google_compute_target_pool.infra.self_link}"
  ip_address = "${google_compute_address.infra.address}"
  port_range = "80"
}
resource "google_compute_forwarding_rule" "https-infra" {
  name = "infra-www-https-forwarding-rule"
  target = "${google_compute_target_pool.infra.self_link}"
  ip_address = "${google_compute_address.infra.address}"
  port_range = "443"
}
resource "google_compute_address" "master" {
    name = "master-address"
}
resource "google_compute_target_pool" "master" {
  name = "master-target-pool"
  instances = ["${google_compute_instance.master1.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.http.name}"]
}
resource "google_compute_forwarding_rule" "https-master" {
  name = "master-www-https-forwarding-rule"
  target = "${google_compute_target_pool.master.self_link}"
  ip_address = "${google_compute_address.master.address}"
  port_range = "8443"
}
resource "google_compute_http_health_check" "http" {
  name = "www-http-basic-check"
  request_path = "/"
  check_interval_sec = 1
  healthy_threshold = 1
  unhealthy_threshold = 10
  timeout_sec = 1
}
