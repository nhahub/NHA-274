# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Node Group Role
resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.cluster_name}-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# Load Balancer Controller Role
resource "aws_iam_role" "lbc_role" {
  name = "lbc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect    = "Allow"
      Sid       = ""
      Principal = { Service = "pods.eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "lbc_policy" {
  name   = "lbc-policy"
  policy = file("${path.module}/../../policies/iam_lbc.json")
}

resource "aws_iam_role_policy_attachment" "lbc_attach" {
  role       = aws_iam_role.lbc_role.name
  policy_arn = aws_iam_policy.lbc_policy.arn
}

# External Secrets Operator Role
resource "aws_iam_role" "eso" {
  name = "eso-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect    = "Allow"
      Sid       = ""
      Principal = { Service = "pods.eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "eso_policy" {
  name   = "eso-policy"
  policy = file("${path.module}/../../policies/iam_eso.json")
}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso.name
  policy_arn = aws_iam_policy.eso_policy.arn
}

# External DNS Role
resource "aws_iam_role" "edns_role" {
  name = "edns_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect    = "Allow"
      Sid       = ""
      Principal = { Service = "pods.eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "edns_policy" {
  name   = "edns-policy"
  policy = file("${path.module}/../../policies/iam-EDNS.json")
}

resource "aws_iam_role_policy_attachment" "edns_attach" {
  role       = aws_iam_role.edns_role.name
  policy_arn = aws_iam_policy.edns_policy.arn
}

# EBS CSI Driver Role
resource "aws_iam_role" "ebs_role" {
  name = "ebs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      Effect    = "Allow"
      Sid       = ""
      Principal = { Service = "pods.eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_attach" {
  role       = aws_iam_role.ebs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
