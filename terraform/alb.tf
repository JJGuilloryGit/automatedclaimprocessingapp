resource "aws_lb" "alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.alb_sg.id]
  tags = { Name = "${var.project_name}-${var.environment}-alb" }
}

resource "aws_lb_target_group" "app" {
  name_prefix = "claim-"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"
  
  lifecycle {
    create_before_destroy = true
  }
  health_check {
    path                = "/health"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
