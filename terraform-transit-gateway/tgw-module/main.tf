provider "aws" {
  profile = var.aws_profile
  region  = var.region
}

resource "aws_ec2_transit_gateway" "dev-tgw" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "${var.env}-tgw"
  }
  auto_accept_shared_attachments = "enable"
}

#VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-vpc-attach-1" {
  subnet_ids = [ "${data.aws_subnet.subnet-a.id}", "${data.aws_subnet.subnet-b.id}", "${data.aws_subnet.subnet-c.id}" ]
  vpc_id = "${data.aws_vpc.devVPC.id}"
  transit_gateway_id = aws_ec2_transit_gateway.dev-tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${var.env}-tgw-attachment"
  }
}

# Route table
resource "aws_ec2_transit_gateway_route_table" "tgw-rt-1" {
  transit_gateway_id = aws_ec2_transit_gateway.dev-tgw.id
  tags = {
    Name = "${var.env}-tgw-rt-1"
  }
}

# Route Table association
# Allow traffic from the VPC attachments to the Transit Gateway
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-1-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-vpc-attach-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt-1.id
}

# Route table Propagations 
# Allow traffic from the Transit Gateway to the VPC attachments
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-vpc-1-propg" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-vpc-attach-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt-1.id
}

# resource "aws_ec2_transit_gateway_route" "tgw-route-to-sub" {
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw-vpc-attach-1.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt-1.id
# }