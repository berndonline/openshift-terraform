resource "google_compute_instance" "bastion" {
  count = 1
  name = "bastion"
  machine_type = "n1-standard-1"
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
resource "google_compute_instance" "master1" {
  count = 1
  name = "master1"
  machine_type = "n1-standard-2"
  zone = "${var.gcp_zone}"
  tags = ["master"]
  boot_disk {
    initialize_params {
      image = "${var.gcp_amis}"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet.name}"
  }
  metadata {
    sshKeys = "centos:${file(var.bastion_key_path)}"
  }
}
resource "google_compute_instance" "infra1" {
  count = 1
  name = "infra1"
  machine_type = "n1-standard-2"
  zone = "${var.gcp_zone}"
  tags = ["infra"]
  boot_disk {
    initialize_params {
      image = "${var.gcp_amis}"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet.name}"
  }
  metadata {
    sshKeys = "centos:${file(var.bastion_key_path)}"
  }
}
resource "google_compute_instance" "worker1" {
  count = 1
  name = "worker1"
  machine_type = "n1-standard-2"
  zone = "${var.gcp_zone}"
  tags = ["worker"]
  boot_disk {
    initialize_params {
      image = "${var.gcp_amis}"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet.name}"
  }
  metadata {
    sshKeys = "centos:${file(var.bastion_key_path)}"
  }
}
