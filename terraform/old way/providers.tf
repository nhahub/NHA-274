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

data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}


provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.eks, aws_eks_node_group.eks_node_group]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks.name} --region ${var.region}"
  }

  triggers = {
    cluster_endpoint = aws_eks_cluster.eks.endpoint
    cluster_ca_cert  = aws_eks_cluster.eks.certificate_authority[0].data
  }
}
