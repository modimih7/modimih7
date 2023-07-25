# ----------------- DATA ------------------------------

data "aws_lb" "lb" {
  arn = var.alb_arn
}

# ----------------- ECS TASK DEFINATION ------------------------------

resource "aws_cloudwatch_log_group" "service_log_group" {

  name = "/ecs/${var.EnvironmentName}/${var.family}"
  # tags = {
  #   Terraform   = "true"
  #   Environment = "dev"
  #   Application = "service"
  # }
}

module "ecs_task_definition" {

  depends_on = [
    aws_cloudwatch_log_group.service_log_group
  ]

  source = "github.com/mongodb/terraform-aws-ecs-task-definition"
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_RegisterTaskDefinition.html
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition

  family = var.family

  # container_name
  name                     = var.family
  environment              = var.environment
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  image                    = var.image
  cpu                      = var.cpu
  memory                   = var.memory

  essential = var.essential

  execution_role_arn = var.execution_role_arn
  privileged         = var.privileged ? true : false

  command    = var.command
  entryPoint = var.entryPoint

  volumes = var.volumes
  secrets = var.secrets

  # volumesFrom            = local.volumesFrom == "[]" ? "null" : local.volumesFrom

  # healthCheck            = local.healthCheck == "{}" ? "null" : local.healthCheck
  # hostname               = var.hostname == "" ? "null" : var.hostname
  # user                   = var.user == "" ? "null" : var.user
  # systemControls         = local.systemControls == "[]" ? "null" : local.systemControls
  # ulimits                = local.ulimits == "[]" ? "null" : local.ulimits
  # workingDirectory       = var.workingDirectory == "" ? "null" : var.workingDirectory

  portMappings = [
    {
      "hostPort" : var.container_port,
      containerPort = var.container_port,
      protocol      = "TCP"
    },
  ]

  logConfiguration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = "/ecs/${var.EnvironmentName}/${var.family}"
      awslogs-region        = "${var.aws_region}"
      awslogs-stream-prefix = "ecs"
    }
  }
}

# ----------------- ALB TARGET GROUP ------------------------------

resource "aws_lb_target_group" "lb_tg" {
  name        = "${var.cluster_name}-${var.service_name}-${var.EnvironmentName}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    interval            = var.tg_health_check_interval
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = 10
    matcher             = "200,202"
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
  tags = {
    Environment = "${var.EnvironmentName}-${var.service_name}"
  }
}


# ----------------- ALB RULES ------------------------------

resource "aws_lb_listener_rule" "https" {
  count = var.https_listener ? 1 : 0

  listener_arn = var.listener_arn_https

  lifecycle {
    create_before_destroy = true
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }

  condition {
    host_header {
      values = [var.subdomain]
    }
  }
}

resource "aws_lb_listener_rule" "http" {
  count = var.https_listener ? 0 : 1

  listener_arn = var.listener_arn_http

  lifecycle {
    create_before_destroy = true
  }
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }

  condition {
    host_header {
      values = [var.subdomain]
    }
  }
}


# ----------------- ECS SERVICE ------------------------------

# resource "aws_security_group" "ecs_service_sg" {
#   name        = "ecs-${var.cluster_name}-${var.service_name}-sg"
#   description = "Sg for ECS ${var.cluster_name}/${var.service_name} traffic"
#   vpc_id      = var.vpc_id

#   ingress = [
#     {
#       description      = "TLS from VPC"
#       from_port        = var.container_port
#       to_port          = var.container_port
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#       self             = true
#       prefix_list_ids  = null
#       security_groups  = []
#     }
#   ]

#   egress = [
#     {
#       description      = "TLS from VPC"
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
#     Name = "${var.cluster_name}-${var.service_name}"
#   }
# }

resource "aws_ecs_service" "ecs_service" {

  depends_on = [
    aws_cloudwatch_log_group.service_log_group,
  ]
  lifecycle {
    ignore_changes = [desired_count]
  }
  
  name                               = var.service_name
  cluster                            = var.cluster_name
  task_definition                    = module.ecs_task_definition.arn
  desired_count                      = var.scale_min_capacity
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  force_new_deployment               = var.force_new_deployment
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_tg.arn
    container_name   = var.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.ecs_subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

}

# ----------------- DOMAIN ------------------------------

data "aws_route53_zone" "web" {
  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_record" "web" {
  count      = var.create_subdomain ? 1 : 0
  depends_on = [aws_ecs_service.ecs_service]

  zone_id = data.aws_route53_zone.web.id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = data.aws_lb.lb.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}

# ----------------- AUTOSCALING ------------------------------
# ab [options] [http[s]://]hostname[:port]/path
# ab -n 100000 -c 1000 "http://api.output.com:80/"

# cpu base scale

resource "aws_appautoscaling_target" "cpu_scale_up" {
  depends_on = [aws_ecs_service.ecs_service]

  min_capacity       = var.scale_min_capacity
  max_capacity       = var.scale_max_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scale_up_policy" {

  depends_on = [aws_appautoscaling_target.cpu_scale_up]

  name               = "ECSServiceAverageCPUUtilization:${aws_appautoscaling_target.cpu_scale_up.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = aws_appautoscaling_target.cpu_scale_up.scalable_dimension
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# memory base scale

resource "aws_appautoscaling_target" "memory_scale_up" {
  depends_on = [aws_ecs_service.ecs_service, aws_appautoscaling_target.cpu_scale_up]

  min_capacity       = var.scale_min_capacity
  max_capacity       = var.scale_max_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory_scale_up_policy" {

  depends_on = [
    aws_appautoscaling_target.memory_scale_up
  ]

  name               = "ECSServiceAverageMemoryUtilization:${aws_appautoscaling_target.memory_scale_up.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = aws_appautoscaling_target.memory_scale_up.scalable_dimension
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# alb based auto scaling

# resource "aws_appautoscaling_target" "scale_up_policy" {
#   min_capacity       = var.scale_min_capacity
#   max_capacity       = var.scale_max_capacity
#   resource_id        = "service/${var.cluster_name}/${var.service_name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "scale_up_policy" {
#   name               = "ALBRequestCountPerTarget:${aws_appautoscaling_target.scale_up_policy.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = "service/${var.cluster_name}/${var.service_name}"
#   scalable_dimension = aws_appautoscaling_target.scale_up_policy.scalable_dimension
#   service_namespace  = "ecs"

#   target_tracking_scaling_policy_configuration {

#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       # app/my-alb/778d41231b141a0f/targetgroup/my-alb-target-group/943f017f100becff
#       resource_label = "${data.aws_lb.lb.arn_suffix}/${aws_lb_target_group.lb_tg.arn_suffix}"
#     }

#     target_value = var.target_value
#     scale_in_cooldown  = var.scale_in_cooldown
#     scale_out_cooldown = var.scale_out_cooldown
#   }
# }

