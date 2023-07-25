variable "domainName" {
  type    = string
  default = ""
}

variable "aws_profile" {
  
}

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = ""
}

variable "bitbucket_username" {
  type        = string
  description = "Bit bucket username"
  default     = ""
}

variable "bitbucket_credential" {
  type        = string
  description = "Bitbucket password"
  default     = ""
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
  # default = "test"
}

# Codepipeline - admin
variable "bitbucket_repo_admin" {
  type = string
  # default = "" # your repo name
}

variable "branchname_admin" {
  type = string
  # default = "test" your repo name
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

variable "serverless_reports" {
  type        = map(any)
  description = "serverless app configs for codebuild"
  # default = {
  #   "example" = {
  #     "stage"            = ""
  #     "ope_code"       = ""
  #     "bitbucket_repo"   = ""
  #     "bitbucket_branch" = ""
  #     "code_build_env_vars" = [
  #       {
  #         name  = "STAGE"
  #         value = "Build"
  #       }
  #     ]
  #   }
  # }
}
