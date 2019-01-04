resource "google_compute_instance" "bastion" {
  count = 1
  name = "bastion"
  machine_type = "f1-micro"
  zone = "${var.gcp_zone}"
  tags = ["bastion"]
  boot_disk {
    initialize_params {
      image = "${var.gcp_amis}"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet.name}"
    access_config {
        # Ephemeral
    }
  }
  metadata_startup_script = "${data.template_file.sysprep-bastion.rendered}"
  metadata {
    sshKeys = "centos:${file(var.bastion_key_path)}"
  }
}
