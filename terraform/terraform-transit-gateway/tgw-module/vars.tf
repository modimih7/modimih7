variable "region" {
  type = string
  # default = "ap-south-1"
}

variable "aws_profile" {
  type = string
}

variable "env" {
  type = string
  # default = "test"
}

variable "vpc_name_for_filter" {
  type = string
  # default = "devVPC"
}

variable "sharing_account_id" {
  type = string
  # default = "your acount name"
}
  