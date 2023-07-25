# GENERAL

EnvironmentName = "dev" # dev and prod environement

# VPC

vpc_id = "Required Fild" # your vpcID

# not private (demo)

private_subnets = ["Required Fild"] # your private subnetID

public_subnets = ["Required Fild"] # your public subnetID

# aws

aws_profile = "Required Fild"

aws_region = "eu-west-2" 

bitbucket_credential = "Required Fild" # your bitbucket credential

bitbucket_username	 = "Required Fild" # your bitbucket name

frountend = {}

// pipeline_sns_target = ["Required Fild"] # this fild is not required

serverless_reports = {}
# ALB
alb_name           = "Required Fild" # your alb name
certificate_domain = "*.test.com" # your domain name

# ECS

ecs_cluster_name = "test-new" # your cluster name

ecs_assign_public_ip = false

ecs_service = {
  "test-feed-new" = {

    # ecs task defination
    image          = "Required Fild"
    family         = "test-feed-new"
    cpu            = 1024
    memory         = 2048
    container_port = 4000
    environment = [
      {"name": "production", "value": "production"}
    ]
    # execution_role_arn = "" # only required when using custom role

    # ecs service
    service_name      = "test-feed-new"
    health_check_path = "/health"

    # autoscale
    cpu_target_value    = 70
    memory_target_value = 70
    scale_min_capacity  = 25
    scale_max_capacity  = 30

    # alb
    path_pattern = ["/", "/*"]

    # route 53
    create_subdomain = true
    root_domain      = "test.com"
    subdomain        = "demo.test.com"
  },

}