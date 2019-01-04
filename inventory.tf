data "template_file" "inventory" {
  template = "${file("${path.cwd}/helper_scripts/ansible-hosts.template.txt")}"
  vars {
    public_subdomain = "paas.hostgate.net"
    admin_hostname = "console-paas.hostgate.net"
    master1_hostname = "${google_compute_instance.master1.private_dns}"
    infra1_hostname = "${google_compute_instance.infra1.private_dns}"
    worker1_hostname = "${google_compute_instance.worker1.private_dns}"
    demo_htpasswd = "${var.htpasswd}"
  }
}
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory/ansible-hosts"
}
