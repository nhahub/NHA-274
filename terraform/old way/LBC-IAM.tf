resource "aws_iam_role" "lbc_role" {
  name = "lbc-role"

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
      }
    ]
  })
}

resource "aws_iam_policy" "lbc_policy" {
  name   = "lbc-policy"
  policy = file("policies/iam_lbc.json")
}

resource "aws_iam_role_policy_attachment" "lbc_attach" {
  role       = aws_iam_role.lbc_role.name
  policy_arn = aws_iam_policy.lbc_policy.arn
}

resource "aws_eks_pod_identity_association" "lbc_pod_identity_association" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "lbc-sa"
  role_arn        = aws_iam_role.lbc_role.arn
}
