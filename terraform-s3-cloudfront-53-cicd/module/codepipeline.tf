resource "aws_iam_role" "codepipeline_role" {
  name = "${var.domainName}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attaching policy to our role 
resource "aws_iam_role_policy_attachment" "iam_www_role_attachment" {
  role       = aws_iam_role.codepipeline_role.id
  policy_arn = var.codepipeline_policy_arn
}
# www

# resource "aws_iam_role_policy_attachment" "codepipeline_policy_attach_www" {
#   # for_each   = tomap(var.frontend)
#   policy_arn = "arn:aws:iam::036114964416:policy/codepipeline_policy"
#   role       = aws_iam_role.codepipeline_role.id
# }

resource "aws_codepipeline" "codepipeline_www" {
  for_each = tomap(var.frontend)
  name     = "${each.key}-${each.value["ope_code"]}"

  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = data.aws_s3_bucket.codepipeline_bucket_www.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      # provider = "BitBucket"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = [
        "wwwdomainname",
      ]
      configuration = {
        ConnectionArn        = var.bitbcuket_codestar_arn
        FullRepositoryId     = var.bitbucket_repo_www
        BranchName           = var.branchname_www
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "BuildFrontend"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "wwwdomainname",
      ]
      output_artifacts = [
        "wwwdomainnameout",
      ]
      version = "1"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
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
        )
        ProjectName = "${each.key}-${each.value["ope_code"]}"
      }
    }
  }
}


resource "aws_codepipeline" "codepipeline_admin" {
  for_each = tomap(var.admin)
  name     = "${each.key}-${each.value["ope_code"]}"

  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = data.aws_s3_bucket.codepipeline_bucket_www.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      # provider = "BitBucket"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = [
        "admindomainname",
      ]
      configuration = {
        ConnectionArn        = var.bitbcuket_codestar_arn
        FullRepositoryId     = var.bitbucket_repo_admin
        BranchName           = var.branchname_admin
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "BuildFrontend"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "admindomainname",
      ]
      output_artifacts = [
        "admindomainnameout",
      ]
      version = "1"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
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
        )
        ProjectName = "${each.key}-${each.value["ope_code"]}"
      }
    }
  }
}

#############################################
# Codepipeline policy - It should be in there already because all domain's artifacts are in the htis bucket
#############################################
# resource "aws_iam_policy" "codepipeline_policy" {
#   name = "codepipeline_policy"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect":"Allow",
#       "Action": [
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketVersioning",
#         "s3:PutObjectAcl",
#         "s3:PutObject"
#       ],
#       "Resource": [
#         "${aws_s3_bucket.codepipeline_bucket.arn}",
#         "${aws_s3_bucket.codepipeline_bucket.arn}/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codestar-connections:UseConnection"
#       ],
#       "Resource": "arn:aws:codestar-connections:us-east-1:537064189997:connection/88b4d19c-4b49-4a60-81b4-17fc4a423fde"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codebuild:BatchGetBuilds",
#         "codebuild:StartBuild"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }


# arn:aws:codestar-connections:us-east-1:537064189997:connection/88b4d19c-4b49-4a60-81b4-17fc4a423fde