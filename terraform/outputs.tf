output "route53_admin_panel" {
  description = "Name servers for the Route53 hosted zone"
  value = aws_route53_zone.admin_panel.name_servers
}
output "route53_users_domain" {
  description = "Name servers for the Route53 hosted zone"
  value = aws_route53_zone.users_domain.name_servers
}
