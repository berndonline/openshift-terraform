
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
resource "aws_instance" "bastion" {
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.small"
  subnet_id            = "${aws_subnet.PublicSubnetA.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
    "${aws_security_group.sec_bastion.id}",
  ]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.auth.id}"
  user_data = "${data.template_file.sysprep-bastion.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_launch_configuration" "launch_master" {
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.large"
  security_groups = ["${aws_security_group.sec_openshift.id}"]
  key_name = "${aws_key_pair.auth.id}"
  user_data = "${data.template_file.sysprep-master.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_launch_configuration" "launch_infra" {
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.large"
  security_groups = ["${aws_security_group.sec_openshift.id}"]
  key_name = "${aws_key_pair.auth.id}"
  user_data = "${data.template_file.sysprep-infra.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_launch_configuration" "launch_worker" {
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.large"
  security_groups = ["${aws_security_group.sec_openshift.id}"]
  key_name = "${aws_key_pair.auth.id}"
  user_data = "${data.template_file.sysprep-worker.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "group_master" {
  launch_configuration = "${aws_launch_configuration.launch_master.id}"
  vpc_zone_identifier = ["${aws_subnet.PrivateSubnetA.id}","${aws_subnet.PrivateSubnetB.id}","${aws_subnet.PrivateSubnetC.id}"]
  min_size = 3
  max_size = 3
  tag {
    key = "Name"
    value = "Master"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "group_infra" {
  launch_configuration = "${aws_launch_configuration.launch_infra.id}"
  vpc_zone_identifier = ["${aws_subnet.PrivateSubnetA.id}","${aws_subnet.PrivateSubnetB.id}","${aws_subnet.PrivateSubnetC.id}"]
  min_size = 3
  max_size = 3
  tag {
    key = "Name"
    value = "Infra"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "group_worker" {
  launch_configuration = "${aws_launch_configuration.launch_worker.id}"
  vpc_zone_identifier = ["${aws_subnet.PrivateSubnetA.id}","${aws_subnet.PrivateSubnetB.id}","${aws_subnet.PrivateSubnetC.id}"]
  min_size = 3
  max_size = 3
  tag {
    key = "Name"
    value = "Worker"
    propagate_at_launch = true
  }
}
