output "cloudfront_www_id" {
  value = local.cloudfront_www_id
}

output "out_www" {
  value = tomap(module.codebuild_www)
}

output "out_admin" {
  value = tomap(module.codebuild_admin)
}

