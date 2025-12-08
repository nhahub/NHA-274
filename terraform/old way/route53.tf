resource "aws_route53_zone" "admin_panel" {
  name = var.panel_domain
  
  tags = {
    Name = "admin panel Domain"
  }
}


resource "aws_route53_zone" "users_domain" {
  name = var.users_domain
  
  tags = {
    Name = "users domain Domain"
  }
}
