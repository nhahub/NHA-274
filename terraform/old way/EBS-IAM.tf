resource "aws_iam_role" "ebs_role" {
  name = "ebs_role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })


}


resource "aws_iam_role_policy_attachment" "ebs-attach" {
  role       = aws_iam_role.ebs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "ebs_pod_identity_association" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "ebs-sa"
  role_arn        = aws_iam_role.ebs_role.arn
}
