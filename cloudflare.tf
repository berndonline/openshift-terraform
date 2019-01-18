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
resource "cloudflare_record" "console-aio" {
  domain  = "${var.domain}"
  name    = "console-aio"
  value   = "${aws_lightsail_static_ip.aio_ip.ip_address}"
  type    = "A"
  proxied = false
}
resource "cloudflare_record" "wildcard-aio" {
  domain  = "${var.domain}"
  name    = "*.aio"
  value   = "${aws_lightsail_static_ip.aio_ip.ip_address}"
  type    = "A"
  proxied = false
}
