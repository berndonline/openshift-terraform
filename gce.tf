resource "google_compute_instance" "bastion" {
  count = 1
  name = "bastion"
  machine_type = "f1-micro"
  zone = "${var.gcp_zone}"
  tags = ["bastion"]

  disk {
    image = "${var.gcp_amis}"
  }
  network_interface {
    network = "vpc"
    subnetwork = "subnet-a"
    access_config {
        # Ephemeral
    }
  }
  provisioner "remote-exec" {
        inline = "${data.template_file.sysprep-bastion.rendered}"
        connection {
            type = "ssh"
            user = "centos",
            private_key = "${gcp_key_pair.bastion.id}"
        }
  }
  metadata {
    sshKeys = "centos:${file(var.bastion_key_path)}"
  }
}
