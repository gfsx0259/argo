resource "helm_release" "cert_manager_helm" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.14.5"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "issuer" {
  yaml_body          = file("${path.module}/04-issuer.yaml")
  override_namespace = kubernetes_namespace.cert_manager.metadata.0.name
  depends_on = [
    helm_release.cert_manager_helm,
  ]
}

resource "kubectl_manifest" "certificate" {
  yaml_body          = file("${path.module}/05-certificate.yaml")
  override_namespace = kubernetes_namespace.cert_manager.metadata.0.name
  depends_on = [
    helm_release.cert_manager_helm,
    kubectl_manifest.issuer,
  ]
}

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body          = file("${path.module}/06-cluster-issuer.yaml")
  override_namespace = kubernetes_namespace.cert_manager.metadata.0.name
  depends_on = [
    helm_release.cert_manager_helm,
    kubectl_manifest.certificate,
  ]
}