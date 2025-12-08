resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = var.eks_version
  node_group_name = "${var.cluster_name}-nodes"

  node_role_arn = aws_iam_role.eks_node_group_role.arn
  subnet_ids    = aws_subnet.private[*].id

  capacity_type  = "ON_DEMAND"
  instance_types = [var.node_group_instance_type]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

}