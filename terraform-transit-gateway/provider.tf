terraform {
  backend "s3" {
    bucket = "dp-state-files"
    key    = "tgw/tgw-terraform.tfstate"
    region = "eu-west-2"
    shared_credentials_file = "~/.aws/credentials"
    profile = "test" # set to your profile
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# provider "aws" {
#   profile = var.aws_profile
#   region  = var.region
# }
