output "alb_dns_name" {
  value = "${aws_lb.master_alb.dns_name}"
}
output "nlb_dns_name" {
  value = "${aws_lb.infra_alb.dns_name}"
}
