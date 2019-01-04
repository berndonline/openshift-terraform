data "template_file" "inventory" {
  template = "${file("${path.cwd}/helper_scripts/ansible-hosts.template.txt")}"
  vars {
    public_subdomain = "aws-paas.hostgate.net"
    admin_hostname = "console-aws-paas.hostgate.net"
    master1_hostname = "${aws_instance.master1.private_dns}"
    infra1_hostname = "${aws_instance.infra1.private_dns}"
    worker1_hostname = "${aws_instance.worker1.private_dns}"
    demo_htpasswd = "${var.htpasswd}"
  }
}
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory/ansible-hosts"
}
