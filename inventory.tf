data "template_file" "inventory" {
  template = "${file("${path.cwd}/helper_scripts/ansible-hosts.template.txt")}"
  vars {
    public_subdomain = "${aws_lb.infra_alb.dns_name}"
    admin_hostname = "${aws_lb.master_alb.dns_name}"
    master1_hostname = "${aws_instance.master1.private_dns}"
    master2_hostname = "${aws_instance.master2.private_dns}"
    master3_hostname = "${aws_instance.master3.private_dns}"
    infra1_hostname = "${aws_instance.infra1.private_dns}"
    infra2_hostname = "${aws_instance.infra2.private_dns}"
    infra3_hostname = "${aws_instance.infra3.private_dns}"
    worker1_hostname = "${aws_instance.worker1.private_dns}"
    worker2_hostname = "${aws_instance.worker2.private_dns}"
    worker3_hostname = "${aws_instance.worker3.private_dns}"
  }
}
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory/ansible-hosts"
}
