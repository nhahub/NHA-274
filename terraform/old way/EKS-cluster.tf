resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.eks_cluster_role.arn 

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = aws_subnet.private[*].id
  }


  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.4-eksbuild.1"
}