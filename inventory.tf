data "template_file" "inventory" {
  template = "${file("${path.cwd}/helper_scripts/ansible-hosts.template.txt")}"
  vars {
    public_subdomain = "${var.ocp_subdomain}"
    admin_hostname = "${var.ocp_console}"
    aio_hostname = "${aws_lightsail_instance.aio.private_dns}"
    admin_username = "${var.ocp_username}"
    admin_htpasswd = "${var.ocp_htpasswd}"
  }
}
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory/ansible-hosts"
}
