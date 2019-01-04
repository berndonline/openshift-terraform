data "template_file" "sysprep-bastion" {
  template = "${file("./helper_scripts/sysprep-bastion.sh")}"
}
data "template_file" "sysprep-openshift" {
  template = "${file("./helper_scripts/sysprep-openshift.sh")}"
}
