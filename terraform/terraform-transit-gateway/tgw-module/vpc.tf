# myVPC
data "aws_vpc" "devVPC" {
    filter {
      name = "tag:Name"
      values = [ "*${var.vpc_name_for_filter}*" ]
    }
}

# -private-subnet-
data "aws_subnet" "subnet-a" {
  filter {
    name = "tag:Name"
    values = [ "*-private-subnet*" ]
  }
  availability_zone = "${var.region}a"
}

data "aws_subnet" "subnet-b" {
  filter {
    name = "tag:Name"
    values = [ "*-private-subnet*" ]
  }
  availability_zone = "${var.region}b"
}

data "aws_subnet" "subnet-c" {
  filter {
    name = "tag:Name"
    values = [ "*-private-subnet*" ]
  }
  availability_zone = "${var.region}c"
}

# Route table
data "aws_route_table" "rt-private-a" {
  subnet_id = data.aws_subnet.subnet-a.id
}