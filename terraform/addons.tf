resource "helm_release" "argocd" {
  depends_on = [aws_eks_node_group.eks_node_group]

  name                       = "argocd"
  chart                      = "argo-cd"
  disable_openapi_validation = true

  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"

  create_namespace = true

  values = [
    templatefile("${path.module}/values/argo-values.tpl", {
      panel_domain = var.panel_domain
    })
  ]
}

resource "helm_release" "argocd-apps" {
  depends_on = [helm_release.argocd]

  name                       = "argocd-apps"
  chart                      = "argocd-apps"
  disable_openapi_validation = true

  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"

  create_namespace = true


  values = [
    templatefile("${path.module}/values/argocd-apps-values.tpl", {
      cluster_name = var.cluster_name
      vpc_id       = aws_vpc.main.id
      aws_region   = var.region
      users_domain = var.users_domain
      panel_domain = var.panel_domain
      sslCertificateArn = aws_acm_certificate.users.arn

    })
  ]
}