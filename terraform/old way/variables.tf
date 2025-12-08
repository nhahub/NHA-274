variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "cluster_name" {
  type    = string
  default = "EKS-cluster"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "node_group_instance_type" {
  type    = string
  default = "c7i-flex.large"
}

variable "eks_version" {
  type    = string
  default = "1.34"
}
variable "users_domain" {
  default = "shebl22.me"
}
variable "panel_domain" {
  default = "shebl22vip.tech"
}

locals {
  secrets = yamldecode(file("${path.module}/variables.yaml"))
}