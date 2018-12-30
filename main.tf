provider "aws" {
  region = "us-east-1"
}

# Security Groups
resource "aws_security_group" "echo" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.sg_vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = []
    self            = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB
resource "aws_lb" "echo" {
  depends_on      = ["aws_security_group.echo"]
  idle_timeout    = "${var.alb_idle_timeout}"
  internal        = "${var.alb_internal}"
  name            = "${var.alb_name}"
  security_groups = "${var.alb_sgs}"
  subnets         = "${var.alb_subnets}"

  enable_deletion_protection = "${var.alb_deletion_protection}"

  tags {}
}

output "alb_a_record" {
  value = "${aws_lb.echo.dns_name}"
}

# Target Group
resource "aws_lb_target_group" "echo" {
  name     = "${var.lb_tg_name}"
  port     = "${var.lb_tg_port}"
  protocol = "${var.lb_tg_protocol}"
  vpc_id   = "${aws_security_group.echo.vpc_id}"

  health_check {
    healthy_threshold   = "${var.hc_healthy_threshold}"
    unhealthy_threshold = "${var.hc_unhealthy_threshold}"
    timeout             = "${var.hc_timeout}"
    path                = "${var.hc_path}"
    interval            = "${var.hc_interval}"
    matcher             = "${var.hc_matcher}"
  }
}

# LB Listener
resource "aws_lb_listener" "echo" {
  depends_on        = ["aws_lb.echo"]
  load_balancer_arn = "${aws_lb.echo.arn}"
  port              = "${var.lb_listener_port}"

  default_action {
    type             = "${var.lb_listener_action_type}"
    target_group_arn = "${aws_lb_target_group.echo.arn}"
  }
}

# Launch Configuration
resource "aws_launch_configuration" "echo" {
  name              = "${var.lc_name}"
  image_id          = "${var.lc_image_id}"
  instance_type     = "${var.lc_instance_type}"
  key_name          = "${var.lc_key_name}"
  security_groups   = ["${aws_security_group.echo.id}"]
  enable_monitoring = "${var.lc_enable_monitoring}"
  ebs_optimized     = "${var.lc_ebs_optimized}"

  root_block_device {
    volume_type           = "${var.lc_volume_type}"
    volume_size           = "${var.lc_volume_size}"
    delete_on_termination = "${var.lc_delete_on_termination}"
  }
}

# Auto scaling group
resource "aws_autoscaling_group" "echo" {
  depends_on                = ["aws_lb.echo", "aws_lb_listener.echo", "aws_launch_configuration.echo"]
  desired_capacity          = "${var.asg_desired_capacity}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "${var.asg_health_check_type}"
  launch_configuration      = "${aws_launch_configuration.echo.name}"
  max_size                  = "${var.asg_max_size}"
  min_size                  = "${var.asg_min_size}"
  name                      = "${var.asg_name}"

  vpc_zone_identifier = "${var.asg_vpc_zone_identifier}"
  target_group_arns   = ["${aws_lb_target_group.echo.arn}"]
}
