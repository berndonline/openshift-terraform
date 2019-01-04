resource "gcp_key_pair" "bastion" {
  key_name   = "${var.bastion_key_name}"
  public_key = "${file(var.bastion_key_path)}"
}
resource "google_compute_instance" "bastion" {
  count = 1
  name = "bastion"
  machine_type = "f1-micro"
  zone = "${var.gcp_region}"
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
}
