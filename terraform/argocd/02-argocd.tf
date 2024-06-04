resource "helm_release" "argocd_helm" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata.0.name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version     = "7.1.1"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}
