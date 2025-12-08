resource "aws_acm_certificate" "users" {
  domain_name       = var.users_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = var.users_domain
    Environment = "production"
  }
}

resource "aws_route53_record" "users_validation" {
  for_each = {
    for dvo in aws_acm_certificate.users.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.users_domain.zone_id
}

output "users_certificate_arn" {
  description = "ARN of the users domain SSL certificate"
  value       = aws_acm_certificate.users.arn
}