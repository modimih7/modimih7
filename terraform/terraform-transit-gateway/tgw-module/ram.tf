resource "aws_ram_resource_share" "ram" {
  name = "${var.env}-tgw-ram"
  allow_external_principals = true
}

resource "aws_ram_resource_association" "ram-res-assoc" {
  resource_arn = aws_ec2_transit_gateway.dev-tgw.arn
  resource_share_arn = aws_ram_resource_share.ram.arn
}

# Another account ID (principal association)
resource "aws_ram_principal_association" "ram-association" {
  principal = var.sharing_account_id # Account ID of the another account
  resource_share_arn = aws_ram_resource_share.ram.arn
}