resource "helm_release" "ingress_helm" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata.0.name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"

  set {
    name  = "targetNamespace"
    value = "ingress_nginx"
  }

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}
