# myVPC
data "aws_vpc" "test" {
    filter {
      name = "tag:Name"
      values = [ "${var.vpc_name_for_filter}" ]
    }
}

# -private-subnet-
data "aws_subnet" "test" {
  filter {
    name = "tag:Name"
    values = [ "public-subnet-1" ]
  }
  availability_zone = var.availability_zone
}

# data "aws_security_group" "testSgroup" {
#   name = "test-security-group"
#   vpc_id = data.aws_vpc.test.id
# }

resource "aws_security_group" "devsg" {
  name        = "${terraform.workspace}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id = data.aws_vpc.test.id
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Name = "${terraform.workspace}-default-sg"
  }
}
