resource "aws_lb" "master_alb" {
  name            = "master_alb"
  subnets         = ["${aws_subnet.PublicSubnetA.id}","${aws_subnet.PublicSubnetB.id}","${aws_subnet.PublicSubnetC.id}"]
  security_groups = ["${aws_security_group.sec_master_alb.id}"]
  internal        = false
  idle_timeout    = 60
  tags {
    Name    = "master_alb"
  }
}
resource "aws_lb" "infra_alb" {
  name            = "infra_alb"
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
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.default.id}"
  tags {
    name = "group_master_alb"
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
    port                = 8443
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
resource "aws_autoscaling_attachment" "autoscale_master_alb" {
  alb_target_group_arn   = "${aws_lb_target_group.group_master_alb.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.group_master.id}"
}
resource "aws_autoscaling_attachment" "autoscale_infra_alb" {
  alb_target_group_arn   = "${aws_lb_target_group.group_infra_alb.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.group_infra.id}"
}
resource "aws_lb_listener" "listener_master_alb" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = 8443
  protocol          = "HTTPS"
  default_action {
    target_group_arn = "${aws_lb_target_group.group_master_alb.arn}"
    type             = "forward"
  }
}
resource "aws_lb_listener" "listener_infra_alb" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_lb_target_group.group_infra_alb.arn}"
    type             = "forward"
  }
}
