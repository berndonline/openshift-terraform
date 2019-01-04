output "bastion" {
  value = "${join(" ", google_compute_instance.bastion.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}
output "master_public_ip" {
  value = "${google_compute_address.master.address}"
}
output "infra_public_ip" {
  value = "${google_compute_address.infra.address}"
}
