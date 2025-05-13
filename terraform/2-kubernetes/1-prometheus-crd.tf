data "kubernetes_namespace" "observability" {
  metadata {
    name = "poc-observability"
  }
}

# resource "helm_release" "prometheus-operator-crds" {
#   chart      = "prometheus-operator-crds"
#   repository = local.helm.repository.prometheus-community
#   name       = "prometheus-operator-crds"
#   namespace  = kubernetes_namespace.observability.metadata[0].name
#   version    = "18.0.1"
# }


