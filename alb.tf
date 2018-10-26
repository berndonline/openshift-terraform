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
resource "aws_lb_target_group" "group_master_alb" {
  name     = "master-alb-target-group"
  port     = "8443"
  protocol = "TCP"
  vpc_id   = "${aws_vpc.default.id}"
  tags {
    name = "group_master_alb"
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
resource "aws_lb_target_group_attachment" "attachment_master1_alb" {
  target_group_arn = "${aws_lb_target_group.group_master_alb.arn}"
  target_id        = "${aws_instance.master1.id}"
  port             = 8443
}
