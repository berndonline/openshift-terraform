resource "aws_lb" "master_alb" {
  name               = "master"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.PublicSubnetA.id}"]
  enable_cross_zone_load_balancing  = true
  tags {
    Name = "master_alb"
  }
}
resource "aws_lb" "infra_alb" {
  name               = "infra"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.PublicSubnetA.id}"]
  enable_cross_zone_load_balancing  = true
  tags {
    Name = "infra_alb"
  }
}
resource "aws_lb_target_group" "group_master_alb" {
  name     = "master-alb-target-group"
  port     = "8443"
  protocol = "TCP"
  vpc_id   = "${aws_vpc.default.id}"
  tags {
    name = "group_master_alb"
  }
}
resource "aws_lb_target_group" "group_infra_http_alb" {
  name     = "infra-http-alb-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.default.id}"
  tags {
    name = "group_infra_alb"
  }
}
resource "aws_lb_target_group" "group_infra_https_alb" {
  name     = "infra-https-alb-target-group"
  port     = 443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.default.id}"
  tags {
    name = "group_infra_alb"
  }
}
resource "aws_lb_listener" "listener_master_alb" {
  load_balancer_arn = "${aws_lb.master_alb.arn}"
  port              = 8443
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.group_master_alb.arn}"
    type             = "forward"
  }
}
resource "aws_lb_listener" "listener_infra_http_alb" {
  load_balancer_arn = "${aws_lb.infra_alb.arn}"
  port              = 80
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.group_infra_http_alb.arn}"
    type             = "forward"
  }
}
resource "aws_lb_listener" "listener_infra_https_alb" {
  load_balancer_arn = "${aws_lb.infra_alb.arn}"
  port              = 443
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.group_infra_https_alb.arn}"
    type             = "forward"
  }
}
resource "aws_lb_target_group_attachment" "attachment_master1_alb" {
  target_group_arn = "${aws_lb_target_group.group_master_alb.arn}"
  target_id        = "${aws_instance.master1.id}"
  port             = 8443
}
resource "aws_lb_target_group_attachment" "attachment_infra1_http_alb" {
  target_group_arn = "${aws_lb_target_group.group_infra_http_alb.arn}"
  target_id        = "${aws_instance.infra1.id}"
  port             = 80
}
resource "aws_lb_target_group_attachment" "attachment_infra1_https_alb" {
  target_group_arn = "${aws_lb_target_group.group_infra_https_alb.arn}"
  target_id        = "${aws_instance.infra1.id}"
  port             = 443
}
