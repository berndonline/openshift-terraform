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
  name    = "console-aws-paas"
  value   = "${aws_lb.master_alb.dns_name}"
  type    = "CNAME"
  proxied = false
}
resource "cloudflare_record" "wildcard-paas" {
  domain  = "${var.domain}"
  name    = "*.aws-paas"
  value   = "${aws_lb.infra_alb.dns_name}"
  type    = "CNAME"
  proxied = false
}
