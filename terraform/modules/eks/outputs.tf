output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "node_group_id" {
  value = aws_eks_node_group.eks_node_group.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_ca_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}
