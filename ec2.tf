resource "aws_key_pair" "bastion" {
  key_name   = "${var.bastion_key_name}"
  public_key = "${file(var.bastion_key_path)}"
}
resource "aws_instance" "bastion" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.micro"
  subnet_id            = "${aws_subnet.PublicSubnetA.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
    "${aws_security_group.sec_bastion.id}",
  ]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.bastion.id}"
  user_data = "${data.template_file.sysprep-bastion.rendered}"
  tags {
    Name = "Bastion"
  }
}
resource "aws_key_pair" "openshift" {
  key_name   = "${var.openshift_key_name}"
  public_key = "${file(var.openshift_key_path)}"
}
resource "aws_instance" "master1" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetA.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Master-1"
  }
}
resource "aws_instance" "master2" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetB.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Master-2"
  }
}
resource "aws_instance" "master3" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetC.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Master-3"
  }
}
resource "aws_instance" "worker1" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetA.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Worker-1"
  }
}
resource "aws_instance" "worker2" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetB.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Worker-2"
  }
}
resource "aws_instance" "worker3" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetC.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Worker-3"
  }
}
resource "aws_instance" "infra1" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetA.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Infra-1"
  }
}
resource "aws_instance" "infra2" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetB.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Infra-2"
  }
}
resource "aws_instance" "infra3" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PrivateSubnetC.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.sysprep-openshift.rendered}"
  tags {
    Name = "Infra-3"
  }
}
