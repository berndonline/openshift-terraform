output "openshift master" {
  value = "${aws_lb.master_alb.dns_name}"
}
output "openshift subdomain" {
  value = "${aws_lb.infra_alb.dns_name}"
}
output "bastion" {
  value = "${aws_instance.bastion.public_dns}"
}
