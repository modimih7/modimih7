# LOCALS

# ECS CLUSTER
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_caller_identity" "current" {}

# ECS IAM

# resource "aws_iam_role" "ecs_role" {
#   name = "ecsServiceTaskExecution"

#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : "sts:AssumeRole",
#         "Sid" : "",
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : [
#             "ecs.amazonaws.com",
#             "ecs-tasks.amazonaws.com"
#           ]
#         }
#       }
#     ]
#   })
# }

data "aws_iam_role" "ecs_role" {
  name = "ecsServiceTaskExecution"
}

resource "aws_iam_role_policy_attachment" "ecs_role" {
  role       = data.aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS SECURITY GROUPS

resource "aws_security_group" "sg_ecs" {
  name        = "ecs-${var.ecs_cluster_name}-sg"
  description = "Sg for ECS ${var.ecs_cluster_name} service traffic"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = true
      prefix_list_ids  = null
      security_groups  = []
    }
  ]

  egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = null,
      security_groups  = []
    }
  ]

  tags = {
    Name = "ecs-${var.ecs_cluster_name}"
  }
}

# ECS SERVICES

module "fargate" {

  for_each = tomap(var.ecs_service)

  source = "./fargate"

  # general
  EnvironmentName = var.EnvironmentName

  # vpc
  vpc_id      = var.vpc_id
  aws_region  = var.aws_region
  ecs_subnets = var.private_subnets

  # ecs task defination
  image          = each.value["image"]          #"nginx:latest"
  family         = each.value["family"]         # "test-tf"
  cpu            = each.value["cpu"]            # 256
  memory         = each.value["memory"]         # 512
  container_port = each.value["container_port"] # 80

  execution_role_arn = data.aws_iam_role.ecs_role.arn

  # ecs service
  cluster_name                      = aws_ecs_cluster.ecs_cluster.name
  service_name                      = each.value["service_name"]     # "test"
  security_groups                   = [aws_security_group.sg_ecs.id] # []
  assign_public_ip                  = var.ecs_assign_public_ip
  force_new_deployment              = false
  health_check_grace_period_seconds = 10

  # autoscale
  cpu_target_value    = each.value["cpu_target_value"]    # 80
  memory_target_value = each.value["memory_target_value"] # 80
  scale_min_capacity  = each.value["scale_min_capacity"]  # 1
  scale_max_capacity  = each.value["scale_max_capacity"]  # 5
  scale_in_cooldown   = 250
  scale_out_cooldown  = 250

  # alb
  alb_arn            = aws_lb.web.arn
  https_listener     = true # true # This will create alb rules for https if true
  listener_arn_https = aws_lb_listener.https[0].arn
  listener_arn_http  = aws_lb_listener.http.arn

  health_check_path        = each.value["health_check_path"] # "/health"
  path_pattern             = each.value["path_pattern"]      # ["/","/*"]
  tg_health_check_interval = 20

  # route 53
  create_subdomain = each.value["create_subdomain"] # false
  root_domain      = each.value["root_domain"]      # "demo.example.info"
  subdomain        = each.value["subdomain"]        # "test.demo.example.info"
  environment      = each.value["environment"]
}
