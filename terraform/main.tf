terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cluster_name    = var.cluster_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name             = var.cluster_name
  eks_version              = var.eks_version
  cluster_role_arn         = module.iam.eks_cluster_role_arn
  node_group_role_arn      = module.iam.eks_node_group_role_arn
  private_subnet_ids       = module.vpc.private_subnet_ids
  node_group_instance_type = var.node_group_instance_type

  # Pod Identity Role ARNs
  lbc_role_arn  = module.iam.lbc_role_arn
  eso_role_arn  = module.iam.eso_role_arn
  edns_role_arn = module.iam.edns_role_arn
  ebs_role_arn  = module.iam.ebs_role_arn
}

# Route53 and ACM Module
module "route53" {
  source = "./modules/route53"

  users_domain = var.users_domain
  panel_domain = var.panel_domain
}

# SSM Parameter Store Module
module "ssm" {
  source = "./modules/ssm"

  mongo_username    = local.secrets.MONGO_INITDB_ROOT_USERNAME
  mongo_password    = local.secrets.MONGO_INITDB_ROOT_PASSWORD
  mongo_database    = local.secrets.MONGO_INITDB_DATABASE
  paypal_client_id  = local.secrets.PAYPAL_CLIENT_ID
  paypal_app_secret = local.secrets.PAYPAL_APP_SECRET
  jwt_secret        = local.secrets.JWT_SECRET
}

# Providers for Kubernetes and Helm
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
    }
  }
}

# Addons Module
module "addons" {
  source = "./modules/addons"

  cluster_name        = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  region              = var.region
  users_domain        = var.users_domain
  panel_domain        = var.panel_domain
  ssl_certificate_arn = module.route53.users_certificate_arn
  node_group_id       = module.eks.node_group_id
}

# Update kubeconfig
resource "null_resource" "update_kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
  }

  triggers = {
    cluster_name = module.eks.cluster_name
  }
}
