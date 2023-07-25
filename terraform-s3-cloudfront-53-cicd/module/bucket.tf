# 1st domain
resource "aws_s3_bucket" "operator_b2c_bucket" {
  bucket = var.domainName
  tags = {
    Name = var.domainName
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.operator_b2c_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.operator_b2c_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.operator_b2c_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

data "aws_caller_identity" "current" {
}


resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.operator_b2c_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}


# 2nd domain - www
resource "aws_s3_bucket" "operator_b2c_bucket_www" {
  bucket = "www.${var.domainName}"
  tags = {
    Name = "www.${var.domainName}"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl_www" {
  bucket = aws_s3_bucket.operator_b2c_bucket_www.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "example_www" {
  bucket = aws_s3_bucket.operator_b2c_bucket_www.id

  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}

data "aws_iam_policy_document" "s3_policy_www" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.operator_b2c_bucket_www.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity_www.iam_arn]
    }
  }
}


data "aws_caller_identity" "current_www" {
}


resource "aws_s3_bucket_policy" "web_www" {
  bucket = aws_s3_bucket.operator_b2c_bucket_www.id
  policy = data.aws_iam_policy_document.s3_policy_www.json
}

# 3nd domain - admin
resource "aws_s3_bucket" "operator_b2c_bucket_admin" {
  bucket = "admin.${var.domainName}"
  tags = {
    Name = "admin.${var.domainName}"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl_admin" {
  bucket = aws_s3_bucket.operator_b2c_bucket_admin.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "example_admin" {
  bucket = aws_s3_bucket.operator_b2c_bucket_admin.id

  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false

}

data "aws_iam_policy_document" "s3_policy_admin" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.operator_b2c_bucket_admin.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity_admin.iam_arn]
    }
  }
}


data "aws_caller_identity" "current_admin" {
}


resource "aws_s3_bucket_policy" "web_admin" {
  bucket = aws_s3_bucket.operator_b2c_bucket_admin.id
  policy = data.aws_iam_policy_document.s3_policy_admin.json
}

data "aws_s3_bucket" "codepipeline_bucket_www" {
  bucket = "codepipeline-artifects-new"
}

# resource "aws_s3_bucket_acl" "codepipeline_bucket_www_acl" {
#   bucket = data.aws_s3_bucket.codepipeline_bucket_www.id
#   acl    = "private"
# }

data "aws_kms_alias" "s3kmskey" {
  name = "alias/aws/s3"
}
