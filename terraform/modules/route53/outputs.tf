output "admin_panel_nameservers" {
  value = aws_route53_zone.admin_panel.name_servers
}

output "users_nameservers" {
  value = aws_route53_zone.users_domain.name_servers
}

output "users_certificate_arn" {
  value = aws_acm_certificate.users.arn
}
