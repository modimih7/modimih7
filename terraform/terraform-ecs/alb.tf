# http and https security groups for alb
data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.test.com" # your domain name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_security_group" "lb_sg" {
  name = "ecs-test-sg" # your security group
 }
# resource "aws_security_group" "lb_sg" {
#   name        = "sg_alb_${var.alb_name}"
#   description = "Allow ALB inbound HTTP/HTTPS traffic"
#   vpc_id      = var.vpc_id

#   ingress = [
#     {
#       description      = "Allow all traffic at 80"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       self             = false
#       prefix_list_ids  = null
#       security_groups  = []
#     },
#     {
#       description      = "Allow all traffic at 443"
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       self             = false
#       prefix_list_ids  = null
#       security_groups  = []
#     }
#   ]

#   egress = [
#     {
#       description      = "egress all traffic"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       self             = false
#       prefix_list_ids  = null,
#       security_groups  = []
#     }
#   ]

#   tags = {
#     Name = "${var.alb_name}"
#   }
# }

# ALB

resource "aws_lb" "web" {
  depends_on = [data.aws_security_group.lb_sg]

  name               = "${var.alb_name}-${var.EnvironmentName}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.lb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    EnvironmentName = var.EnvironmentName
  }
}

# HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS

resource "aws_lb_listener" "https" {
  count = var.https_listener ? 1 : 0

  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "Direct access is denied"
      status_code  = "401"
    }
  }
}
