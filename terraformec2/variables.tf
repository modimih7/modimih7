variable "region" {
  type = string
  # default = "ap-south-1"
}

variable "aws_profile" {
  type = string
  # default = "default"
}

variable "instance_type" {
  type = string
  # default = "t2.micro"
}

variable "vpc_name_for_filter" {
  type = string
}

variable "availability_zone" {
  type = string
  # default = "ap-south-1a"
}

variable "key_name" {
  type = string
  # default = ""    # Don't add .pem at the end of the file name
}