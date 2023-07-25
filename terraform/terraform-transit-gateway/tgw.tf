module "transit_gateway" {
  source = "./tgw-module"
  aws_profile = var.aws_profile
  env = var.env
  region = var.region
  vpc_name_for_filter = var.vpc_name_for_filter
  sharing_account_id = var.sharing_account_id
}