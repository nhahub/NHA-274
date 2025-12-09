output "route53_admin_panel" {
  description = "Name servers for the Route53 hosted zone"
  value       = module.route53.admin_panel_nameservers
}

output "route53_users_domain" {
  description = "Name servers for the Route53 hosted zone"
  value       = module.route53.users_nameservers
}
# output "BUCKET_NAME" {
#   value = aws_s3_bucket.terraform_state.id
# }
