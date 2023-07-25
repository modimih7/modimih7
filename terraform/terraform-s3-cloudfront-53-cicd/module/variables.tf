variable "domainName" {
  type = string
  # default = "test.com" # set your domain name
}

variable "aws_profile" {
  
}

locals {
  cloudfront_www_id = aws_cloudfront_distribution.cloudfront_www.id
}

variable "bitbcuket_codestar_arn" {
  type = string
  # default = "arn:aws:codestar-connections:us-east-1:537064189997:connection/88b4d19c-4b49-4a60-81b4-17fc4a423fde"
}

variable "codepipeline_policy_arn" {
  type = string
  # default = "arn:aws:iam::537064189997:policy/codepipeline_policy"
}

# Codepipeline - www
variable "bitbucket_repo_www" {
  type = string
  # default = "" # username/repo-name
}

variable "branchname_www" {
  type = string
  # default = "test" # set your branch name
}

# Codepipeline - admin
variable "bitbucket_repo_admin" {
  type = string
  # default = "" # username/repo-name
}

variable "branchname_admin" {
  type = string
  # default = "test"
}

####

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}

variable "bitbucket_username" {
  type        = string
  description = "Bit bucket username"
  default     = null
}

variable "bitbucket_credential" {
  type        = string
  description = "Bitbucket password"
  default     = null
}

variable "build_compute_type" {
  type        = string
  description = "compute type for codebuild"
  default     = "BUILD_GENERAL1_SMALL"
}

variable "extra_permissions" {
  type        = list(any)
  description = "extra permitions for codebuild"
  default     = []
}

variable "docker_privilage" {
  type        = bool
  description = "Provide docker privilages to codebuild"
  default     = false
}

variable "frontend" {
  description = "Nodejs UI app configs for codebuild"
  # default = {
  #   "example" = {
  #     "ope_code"       = ""
  #     "bitbucket_repo"   = ""
  #     "bitbucket_branch" = ""
  #     "s3_bucket_name"   = ""
  #     "code_build_env_vars" = [
  #       {
  #         name  = "STAGE"
  #         value = "Build"
  #       }
  #     ]
  #   }
  # }
}

variable "admin" {
  description = "Nodejs UI app configs for codebuild"
  # default = {
  #   "example" = {
  #     "ope_code"       = ""
  #     "bitbucket_repo"   = ""
  #     "bitbucket_branch" = ""
  #     "s3_bucket_name"   = ""
  #     "code_build_env_vars" = [
  #       {
  #         name  = "STAGE"
  #         value = "Build"
  #       }
  #     ]
  #   }
  # }
}


variable "codebuild_conf" {
  type        = map(any)
  description = "Nodejs UI app configs for codebuild"
  default = {
    #   "example" = {
    #     "ope_code" = ""
    #     "bitbucket_repo" = ""
    #     "bitbucket_branch" = ""
    #     "s3_bucket_name" = ""
    #     "code_build_env_vars" = [
    #       {
    #         name  = "STAGE"
    #         value = "Build"
    #       }
    #     ]
    # }
  }
}