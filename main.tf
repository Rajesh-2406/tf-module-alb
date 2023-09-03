resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_subnet_cidr
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_subnet_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    name = "${var.name}-${var.env}-sg"
  }
}



resource "aws_lb" "main" {
  name               = "${var.name}-${var.env}-lb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets
  tags               = merge({ Name = "${var.name}-${var.env}-lb"}, var.tags)
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:600222537277:certificate/48250658-8c3b-4e4e-9987-49c283dd3857"

  default_action {
    type = "fixed-response"

    fixed_response{
      content_type = "text/plain"
      message_body = "Default Error"
      status_code  = "500"
    }
  }
}