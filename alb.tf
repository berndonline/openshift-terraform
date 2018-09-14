resource "aws_lb" "master_alb" {
  name               = "master"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.PublicSubnetA.id}","${aws_subnet.PublicSubnetB.id}","${aws_subnet.PublicSubnetC.id}"]
  enable_cross_zone_load_balancing  = true
  tags {
    Name = "master_alb"
  }
}
resource "aws_lb" "infra_alb" {
  name            = "infra"
  subnets         = ["${aws_subnet.PublicSubnetA.id}","${aws_subnet.PublicSubnetB.id}","${aws_subnet.PublicSubnetC.id}"]
  security_groups = ["${aws_security_group.sec_infra_alb.id}"]
  internal        = false
  idle_timeout    = 60
  tags {
    Name    = "infra_alb"
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
resource "aws_lb_target_group" "group_infra_alb" {
  name     = "infra-alb-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default.id}"
  tags {
    name = "group_infra_alb"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 80
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
resource "aws_lb_listener" "listener_infra_alb" {
  load_balancer_arn = "${aws_lb.infra_alb.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_lb_target_group.group_infra_alb.arn}"
    type             = "forward"
  }
}
resource "aws_alb_target_group_attachment" "group_master_alb" {
  target_group_arn = "${aws_alb_target_group.group_master.arn}"
  target_id        = ["${aws_instance.master1.id}","${aws_instance.master2.id}","${aws_instance.master3.id}"]
  port             = 8443
}

resource "aws_alb_target_group_attachment" "group_infra_alb" {
  target_group_arn = "${aws_alb_target_group.group_infra.arn}"
  target_id        = ["${aws_instance.infra1.id}","${aws_instance.infra2.id}","${aws_instance.infra3.id}"]
  port             = 80
}
