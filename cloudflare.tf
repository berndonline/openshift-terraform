variable "email" {
}
variable "token" {
}
variable "domain" {
}
provider "cloudflare" {
  email = "${var.email}"
  token = "${var.token}"
}
resource "cloudflare_record" "console-paas" {
  domain  = "${var.domain}"
  name    = "console-gcp-paas"
  value   = "${google_compute_address.master.address}"
  type    = "A"
  proxied = false
}
resource "cloudflare_record" "wildcard-paas" {
  domain  = "${var.domain}"
  name    = "*.gcp-paas"
  value   = "${google_compute_address.infra.address}"
  type    = "A"
  proxied = false
}
