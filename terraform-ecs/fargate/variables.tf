# ----------- General ----------

variable "EnvironmentName" {
  type        = string
  description = "Environment stage for the deployment"
}

# --------  AWS --------

variable "aws_region" {
  type = string
}

# ------------ VPC -------------

variable "vpc_id" {
  type        = string
  description = "aws vpc id"
  default     = ""
}

variable "ecs_subnets" {
  type        = list(any)
  description = "List of subnets for ecs service"
  default     = []
}

# --------- ALB --------------------

variable "alb_arn" {
  type        = string
  description = "Application Load Balencer arn"
  default     = ""
}

variable "tg_health_check_interval" {
  type        = number
  description = "tg health check interval time in sec"
  default     = 20
}

variable "https_listener" {
  type        = bool
  description = "true to set rule for alb https listener rule | false for http"
  default     = true
}

variable "listener_arn_http" {
  type        = string
  description = "HTTP listner arn for Application Load Balencer"
  default     = ""
}

variable "listener_arn_https" {
  type        = string
  description = "HTTPS listner arn for Application Load Balencer"
  default     = ""
}

variable "health_check_path" {
  type        = string
  description = "Health check path for ecs running containers"
  default     = "/"
}

variable "path_pattern" {
  type        = list(any)
  description = "List of paths for alb to route traffic at ecs target group"
  default     = ["/", "/*"]
}

# -------- ecs Task Defination ----------------

variable "family" {
  type        = string
  description = "TaskDefination family name"
}

variable "execution_role_arn" {
  type        = string
  description = "TaskDefination execution IAM role arn for ecs services"
}

variable "container_port" {
  type        = number
  description = "container port"
}
variable "essential" {
  type        = bool
  description = "Is container essential"
  default     = true
}

variable "cpu" {
  type        = number
  description = "Cpu limit for ecs task defination"
}

variable "memory" {
  type        = number
  description = "Memory limit for ecs task defination"
}

variable "image" {
  type        = string
  description = "ECR or docker image url"
}

variable "command" {
  type        = list(any)
  description = "Command that is passed to the container"
  default     = []
}

variable "entryPoint" {
  type        = list(any)
  description = "Entry point that is passed to the container"
  default     = []
}

variable "privileged" {
  type        = bool
  description = "Docker previliges to container"
  default     = false
}

variable "environment" {
  type        = list(any)
  description = "The environment variables to pass to a container: eg: {\"name\": \"VARNAME\", \"value\": \"VARVAL\"}"
  default     = []
}

variable "secrets" {
  type        = list(any)
  description = "The secrets to pass to the container"
  default     = []
}

variable "volumes" {
  type        = list(any)
  description = "A list of volume definitions in JSON format that containers in your task may use"
  default     = []
}

# -------------- ECS Service -----------

variable "cluster_name" {
  type        = string
  description = "Ecs cluster name where services will be created"
}

variable "service_name" {
  type        = string
  description = "ecs service name"
}

variable "assign_public_ip" {
  type        = bool
  description = "Auto assign public ip for ecs containers"
  default     = true
}

variable "force_new_deployment" {
  type        = bool
  description = "Enable to force a new task deployment of the service"
  default     = false
}

variable "desired_count" {
  type        = number
  description = "Desired count of containers"
  default     = 1
}

variable "security_groups" {
  type        = list(any)
  description = "Extra security groups to attach to ecs service"
  default     = []
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "Deployment min healthy percent of container count"
  default     = 100
}

variable "deployment_maximum_percent" {
  type        = number
  description = "Deployment max healthy percent of container count"
  default     = 200
}
# fargate autoscale

variable "scale_min_capacity" {
  type        = number
  description = "Min count of containers"
  default     = 2
}

variable "scale_max_capacity" {
  type        = number
  description = "Max count of containers"
  default     = 20
}

variable "cpu_target_value" {
  type        = number
  description = "Treshold cpu target value for autoscaling ecs service"
  default     = 70
}

variable "memory_target_value" {
  type        = number
  description = "Treshold memory target value for autoscaling ecs service"
  default     = 70
}

variable "scale_in_cooldown" {
  type        = number
  description = "The amount of time, in sec, after a scale in activity completes before another scale in activity can start."
  default     = 250
}

variable "scale_out_cooldown" {
  type        = number
  description = "The amount of time, in sec, after a scale out activity completes before another scale in activity can start."
  default     = 250
}

variable "health_check_grace_period_seconds" {
  type    = number
  default = 30
}

# ROUTE 53

variable "create_subdomain" {
  type        = bool
  default     = false
  description = "true, to create subdomain for the resource | false, if not"
}

variable "root_domain" {
  type        = string
  description = "Hosted domain name eg: example.com"
  default     = ""
}

variable "subdomain" {
  type        = string
  description = "Subdomain name eg: test.example.com"
  default     = ""
}
