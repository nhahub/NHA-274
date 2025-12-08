resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = var.eks_version
  role_arn = var.cluster_role_arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids              = var.private_subnet_ids
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.4-eksbuild.1"
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = var.eks_version
  node_group_name = "${var.cluster_name}-nodes"

  node_role_arn = var.node_group_role_arn
  subnet_ids    = var.private_subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = [var.node_group_instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# Pod Identity Associations
resource "aws_eks_pod_identity_association" "lbc_pod_identity_association" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "lbc-sa"
  role_arn        = var.lbc_role_arn
}

resource "aws_eks_pod_identity_association" "eso_pod_identity_association" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "eso"
  service_account = "eso-sa"
  role_arn        = var.eso_role_arn
}

resource "aws_eks_pod_identity_association" "edns_pod_identity_association" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "edns-sa"
  role_arn        = var.edns_role_arn
}

resource "aws_eks_pod_identity_association" "ebs_pod_identity_association" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "ebs-sa"
  role_arn        = var.ebs_role_arn
}
