output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "lbc_role_arn" {
  value = aws_iam_role.lbc_role.arn
}

output "eso_role_arn" {
  value = aws_iam_role.eso.arn
}

output "edns_role_arn" {
  value = aws_iam_role.edns_role.arn
}

output "ebs_role_arn" {
  value = aws_iam_role.ebs_role.arn
}
