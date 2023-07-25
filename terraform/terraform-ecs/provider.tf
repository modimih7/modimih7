terraform {
  backend "s3" {
    bucket = "test-terraform-statefiles" # your data backup bucket name
    key    = "ecs/ecs-terraform.tfstate"
    region = "eu-west-2"
    shared_credentials_file = "~/.aws/credentials"
    profile = "test"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "test"
  region  = var.aws_region
}
