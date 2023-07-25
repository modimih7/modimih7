provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

data "aws_cloudfront_cache_policy" "default_cache_policy" {
  name = "Managed-CachingOptimized"
}

# 1st domain
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domainName}.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = aws_s3_bucket.operator_b2c_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.operator_b2c_bucket.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  aliases = ["${var.domainName}"]

  enabled         = true
  is_ipv6_enabled = true
  # comment             = "Some comment"
  default_root_object = "index.html"

  # 404 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
  }
  # 403 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
  }
  # 404 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 500
    response_page_path    = "/index.html"
    response_code         = 200
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id  = data.aws_cloudfront_cache_policy.default_cache_policy.id
    target_origin_id = aws_s3_bucket.operator_b2c_bucket.bucket # "s3-cloudfront"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_All"
  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.mysite.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# 2nd domain - www
resource "aws_cloudfront_origin_access_identity" "origin_access_identity_www" {
  comment = "access-identity-www.${var.domainName}.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "cloudfront_www" {
  origin {
    domain_name = aws_s3_bucket.operator_b2c_bucket_www.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.operator_b2c_bucket_www.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity_www.cloudfront_access_identity_path
    }
  }

  aliases = ["www.${var.domainName}"]

  enabled         = true
  is_ipv6_enabled = true
  # comment             = "Some comment"
  default_root_object = "index.html"

  # 404 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
  }
  # 403 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
  }
  # 404 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 500
    response_page_path    = "/index.html"
    response_code         = 200
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id  = data.aws_cloudfront_cache_policy.default_cache_policy.id
    target_origin_id = aws_s3_bucket.operator_b2c_bucket_www.bucket # "s3-cloudfront"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_All"
  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.mysite_star.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# 3rd domain - admin
resource "aws_cloudfront_origin_access_identity" "origin_access_identity_admin" {
  comment = "access-identity-admin.${var.domainName}.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "cloudfront_admin" {
  origin {
    domain_name = aws_s3_bucket.operator_b2c_bucket_admin.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.operator_b2c_bucket_admin.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity_admin.cloudfront_access_identity_path
    }
  }

  aliases = ["admin.${var.domainName}"]

  enabled         = true
  is_ipv6_enabled = true
  # comment             = "Some comment"
  default_root_object = "index.html"

  # 404 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
  }
  # 403 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
  }
  # 404 Error
  custom_error_response {
    error_caching_min_ttl = 86400
    error_code            = 500
    response_page_path    = "/index.html"
    response_code         = 200
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id  = data.aws_cloudfront_cache_policy.default_cache_policy.id
    target_origin_id = aws_s3_bucket.operator_b2c_bucket_admin.bucket # "s3-cloudfront"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_All"
  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn      = data.aws_acm_certificate.mysite_star.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}