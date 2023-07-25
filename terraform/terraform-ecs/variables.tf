# GENERAL

variable "EnvironmentName" {
  type        = string
  description = "staging EnvironmentName, eg: dev, prod, test."
}

# AWS

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile name"
}

# VPC

variable "vpc_id" {
  type        = string
  description = "VPC id"
  default     = ""
}

variable "private_subnets" {
  type        = list(any)
  description = "vpc private subnets"
  default     = []
}

variable "public_subnets" {
  type        = list(any)
  description = "vpc public subnets"
  default     = []
}

# PIPELINE

variable "bitbucket_username" {
  type        = string
  description = "Bit bucket username"
}

variable "bitbucket_credential" {
  type        = string
  description = "Bitbucket password"
}

variable "pipeline_sns_target" {
  type        = list(any)
  description = "email targets for pipelines"
  default     = []
}

variable "frountend" {
  type        = map(any)
  description = "Nodejs UI app configs for codebuild"
  default = {
    "example" = {
      "build_name"       = ""
      "bitbucket_repo"   = ""
      "bitbucket_branch" = ""
      "s3_bucket_name"   = ""
      "stage"            = ""
      "code_build_env_vars" = [
        {
          name  = "STAGE"
          value = "Build"
        }
      ]
    }
  }
}

variable "serverless_reports" {
  type        = map(any)
  description = "serverless app configs for codebuild"
  default = {
    "example" = {
      "stage"            = ""
      "build_name"       = ""
      "bitbucket_repo"   = ""
      "bitbucket_branch" = ""
      "code_build_env_vars" = [
        {
          name  = "STAGE"
          value = "Build"
        }
      ]
    }
  }
}

# ECS

variable "ecs_cluster_name" {
  type    = string
  default = "ecscluster"
}

# ECS SERVICE

variable "ecs_assign_public_ip" {
  type = bool
  default = false 
}

variable "ecs_service" {
  type        = any
  description = "fargate module inputs"
}

# ALB

variable "https_listener" {
  type    = bool
  default = true
}

variable "alb_name" {
  type        = string
  description = "alb name"
  default     = "test-alb"
}

variable "certificate_domain" {
  type        = string
  description = "https certificate domain for alb, eg: *.example.com"
  default     = ""
}
