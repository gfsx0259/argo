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

resource "kubectl_manifest" "project_dev" {
  yaml_body          = file("${path.module}/03-project-dev.yaml")
  override_namespace = kubernetes_namespace.argocd.metadata.0.name
  depends_on = [
    helm_release.argocd_helm,
  ]
}

resource "kubectl_manifest" "project_infra" {
  yaml_body          = file("${path.module}/04-project-infra.yaml")
  override_namespace = kubernetes_namespace.argocd.metadata.0.name
  depends_on = [
    helm_release.argocd_helm,
  ]
}

resource "kubectl_manifest" "example_app" {
  yaml_body          = file("${path.module}/05-example-app.yaml")
  override_namespace = kubernetes_namespace.argocd.metadata.0.name
  depends_on = [
    helm_release.argocd_helm,
  ]
}