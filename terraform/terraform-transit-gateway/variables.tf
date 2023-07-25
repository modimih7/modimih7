variable "region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_name_for_filter" {
  type = string
}

variable "sharing_account_id" {
  type = string
  # default = ""
}