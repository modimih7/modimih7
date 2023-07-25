provider "aws" {
  profile = var.aws_profile
  region  = var.region
}


data "aws_ami" "ubuntu" {
  most_recent = true
#   owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-20220610"]
  }
}

resource "aws_instance" "test" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
#   count = var.instance_count
  subnet_id = data.aws_subnet.test.id
  security_groups = [ resource.aws_security_group.devsg.id ]
  key_name = var.key_name
}
