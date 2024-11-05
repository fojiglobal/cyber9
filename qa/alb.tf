resource "aws_lb_target_group" "qa_tg" {
  name     = "${var.env}-tg-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.qa.id
  health_check {
    healthy_threshold = 2
    interval          = 10
  }
}

resource "aws_lb" "qa_alb" {
  name                       = "${var.env}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.pub_sg.id]
  subnets                    = [aws_subnet.qa_pub_1.id, aws_subnet.qa_pub_2.id]
  drop_invalid_header_fields = true
  tags = {
    Name        = "${var.env}-alb"
    Environment = var.env
  }
}

resource "aws_lb_listener" "qa_https" {
  load_balancer_arn = aws_lb.qa_alb.arn
  port              = var.alb_port_https
  protocol          = var.alb_proto_https
  ssl_policy        = var.alb_ssl_profile
  certificate_arn   = data.aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.qa_tg.arn
  }
}

resource "aws_lb_listener" "qa_http_https" {
  load_balancer_arn = aws_lb.qa_alb.arn
  port              = var.alb_port_http
  protocol          = var.alb_proto_http

  default_action {
    type = "redirect"

    redirect {
      port        = var.alb_port_https
      protocol    = var.alb_proto_https
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "qa_web_rule" {
  listener_arn = aws_lb_listener.qa_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.qa_tg.arn
  }

  condition {
    host_header {
      values = ["qa.fojiapps.com", "www.qa.fojiapps.com"]
    }
  }
}
