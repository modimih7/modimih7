module "cloudfront" {
  source     = "./module"
  domainName = var.domainName
  aws_profile = var.aws_profile
  frontend   = var.frontend
  admin      = var.admin
  aws_region = var.aws_region

  docker_privilage     = false
  bitbucket_username   = var.bitbucket_username
  bitbucket_credential = var.bitbucket_credential
  extra_permissions    = []

  bitbcuket_codestar_arn  = var.bitbcuket_codestar_arn
  codepipeline_policy_arn = var.codepipeline_policy_arn
  bitbucket_repo_www      = var.bitbucket_repo_www
  branchname_www          = var.branchname_www

  bitbucket_repo_admin = var.bitbucket_repo_admin
  branchname_admin     = var.branchname_admin

}



# ############### TODO
# resource "aws_iam_role_policy_attachment" "codepipeline_attachment" {
#   for_each = tomap(var.frontend)

#   role       = module.cloudfront.out_www[each.key].role_id
#   policy_arn = module.codepipeline.codepipeline_policy_www
# }

