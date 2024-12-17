resource "kubernetes_namespace" "observability" {
    metadata {
        name = "observability"
    }
}

resource "helm_release" "prometheus-operator-crds" {
    chart      = "prometheus-operator-crds"
    repository = local.helm.repository.prometheus-community
    name       = "prometheus-operator-crds"
    namespace  = kubernetes_namespace.observability.metadata[0].name
    version    = "14.0.0"
}
