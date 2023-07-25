# www
module "codebuild_www" {

  for_each = tomap(var.frontend)
  source = "cloudposse/codebuild/aws"

  namespace = each.key
  name      = each.value["ope_code"]
  # stage     = each.value["stage"]

  build_image        = "aws/codebuild/standard:5.0"
  build_compute_type = var.build_compute_type
  build_timeout      = 120

  privileged_mode = var.docker_privilage
  aws_region      = var.aws_region

  # source code
  source_type                 = "BITBUCKET"
  artifact_type               = "NO_ARTIFACTS"
  source_location             = each.value["bitbucket_repo"]
  source_credential_user_name = var.bitbucket_username
  source_credential_token     = var.bitbucket_credential

  # Branch name
  source_version = each.value["bitbucket_branch"]

  # Optional extra environment variables
  # environment_variables = each.value["code_build_env_vars"]
  environment_variables = [
    {
      "name" : "bucket_name",
      "value" : "s3://www.${var.domainName}",
      "type" : "PLAINTEXT"
    },
    {
      "name" : "distribution_id",
      "value" : "${aws_cloudfront_distribution.cloudfront_www.id}",
      "type" : "PLAINTEXT"
    }
  ]

  # extra iam policies
  extra_permissions = var.extra_permissions

}

resource "aws_iam_policy" "s3_policy_www" {

  for_each    = tomap(var.frontend)
  name        = "${each.key}-${each.value["ope_code"]}-s3-access"
  path        = "/"
  description = "arn based s3 access policy for codebuild"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "s3:*",
          "Resource" : [
            "arn:aws:s3:::${each.value["s3_bucket_name"]}",
            "arn:aws:s3:::${each.value["s3_bucket_name"]}/*"
          ]
        },
        {
          "Sid" : "VisualEditor2",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*"
        },
        {
          "Sid" : "VisualEditor3",
          "Effect" : "Allow",
          "Action" : [
            "cloudfront:CreateInvalidation"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "codebuild_ui_policy" {
  for_each = tomap(var.frontend)

  role       = "${module.codebuild_www[each.key].role_id}"
  policy_arn = aws_iam_policy.s3_policy_www[each.key].arn
}

resource "aws_iam_role_policy_attachment" "codepipeline_www_policy_attachment" {
  for_each = tomap(var.frontend)

  role       = "${module.codebuild_www[each.key].role_id}"
  policy_arn = var.codepipeline_policy_arn
}



# admin
module "codebuild_admin" {

  for_each = tomap(var.admin)

  source = "cloudposse/codebuild/aws"

  namespace = each.key
  name      = each.value["ope_code"]
  # stage     = each.value["stage"]

  build_image        = "aws/codebuild/standard:5.0"
  build_compute_type = var.build_compute_type
  build_timeout      = 120

  privileged_mode = var.docker_privilage
  aws_region      = var.aws_region

  # source code
  source_type                 = "BITBUCKET"
  artifact_type               = "NO_ARTIFACTS"
  source_location             = each.value["bitbucket_repo"]
  source_credential_user_name = var.bitbucket_username
  source_credential_token     = var.bitbucket_credential

  # Branch name
  source_version = each.value["bitbucket_branch"]

  # Optional extra environment variables
  # environment_variables = each.value["code_build_env_vars"]
  environment_variables = [
    {
      "name" : "bucket_name",
      "value" : "s3://admin.${var.domainName}",
      "type" : "PLAINTEXT"
    },
    {
      "name" : "distribution_id",
      "value" : "${aws_cloudfront_distribution.cloudfront_admin.id}",
      "type" : "PLAINTEXT"
    }
  ]

  # extra iam policies
  extra_permissions = var.extra_permissions

}

resource "aws_iam_policy" "s3_policy_admin" {

  for_each    = tomap(var.admin)
  name        = "${each.key}-${each.value["ope_code"]}-s3-access"
  path        = "/"
  description = "arn based s3 access policy for codebuild"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "s3:*",
          "Resource" : [
            "arn:aws:s3:::${each.value["s3_bucket_name"]}",
            "arn:aws:s3:::${each.value["s3_bucket_name"]}/*"
          ]
        },
        {
          "Sid" : "VisualEditor2",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*"
        },
        {
          "Sid" : "VisualEditor3",
          "Effect" : "Allow",
          "Action" : [
            "cloudfront:CreateInvalidation"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "codebuild_admin_policy" {
  for_each = tomap(var.admin)

  role       = "${module.codebuild_admin[each.key].role_id}"
  policy_arn = aws_iam_policy.s3_policy_admin[each.key].arn
}

resource "aws_iam_role_policy_attachment" "codepipeline_admin_policy_attachment" {
  for_each = tomap(var.admin)

  role       = "${module.codebuild_admin[each.key].role_id}"
  policy_arn = var.codepipeline_policy_arn
}
