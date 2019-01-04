resource "google_compute_instance" "bastion" {
  count = 1
  name = "bastion"
  machine_type = "f1-micro"
  zone = "${var.gcp_zone}"
  tags = ["bastion"]
  boot_disk {
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
  }
  metadata {
    sshKeys = "centos:${file(var.bastion_key_path)}"
  }
}
