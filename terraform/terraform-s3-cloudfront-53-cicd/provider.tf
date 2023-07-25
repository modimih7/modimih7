terraform {
  backend "s3" {
    bucket = "jsr-b2c-terraform-statefiles"  # set your bucket name
    key    = "frontend/frontend-terraform.tfstate" # set your terraform key
    region = "eu-west-2"
    shared_credentials_file = "~/.aws/credentials"
    profile = "test"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13.0" # Using this version because we are using s3_object
    }
  }

  required_version = ">= 0.14.9"
}

# provider "aws" {
#   profile = var.aws_profile
#   region  = "us-east-1"
# }
