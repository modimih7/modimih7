provider "aws" {
  alias  = "test" #For testing
  region = "us-east-1"
  profile = "test"
}

data "aws_route53_zone" "domain" {
  name         = var.domainName
  private_zone = false
}

#Create certificate for domain
# resource "aws_acm_certificate" "mysite" {
#   domain_name       = var.domainName
#   validation_method = "DNS"
# }
# Get simple certificate
data "aws_acm_certificate" "mysite" {
  provider = aws.test
  domain   = var.domainName
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "mysite_star" {
  provider = aws.test
  domain   = "*.${var.domainName}"
  statuses = ["ISSUED"]
}

# Create *.certificate
# resource "aws_acm_certificate" "mysite_star" {
#   domain_name       = "*.${var.domainName}"
#   validation_method = "DNS"
# }

# Creating the record with the cert arn in the zone
# resource "aws_route53_record" "cert_validation" {
#   allow_overwrite = true
#   name            = tolist(data.aws_acm_certificate.mysite.domain_validation_options)[0].resource_record_name
#   records         = [tolist(data.aws_acm_certificate.mysite.domain_validation_options)[0].resource_record_value]
#   type            = tolist(data.aws_acm_certificate.mysite.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.domain.id
#   ttl             = 60
# }

# # For cert validation, we need to create a route53 record that points to the cert.
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = data.aws_acm_certificate.mysite.arn
#   validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
# }

# 1st domain
resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.domain.id
  name    = var.domainName

  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

# 2nd domain - www
resource "aws_route53_record" "web_www" {
  zone_id = data.aws_route53_zone.domain.id
  name    = "www.${var.domainName}"

  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_www.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_www.hosted_zone_id
    evaluate_target_health = false
  }
}

# 3rd domain - admin
resource "aws_route53_record" "web_admin" {
  zone_id = data.aws_route53_zone.domain.id
  name    = "admin.${var.domainName}"

  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_admin.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_admin.hosted_zone_id
    evaluate_target_health = false
  }
}