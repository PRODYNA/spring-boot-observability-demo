resource "helm_release" "opentelemetry-operator" {
  chart      = "opentelemetry-operator"
  repository = local.helm.repository.open-telemetry
  name       = "opentelemetry-operator"
  namespace  = kubernetes_namespace.observability.metadata[0].name
  version    = "0.88.7"

  values = [
    file("helm/opentelemetry-operator.yaml"),
  ]

  depends_on = [
    helm_release.prometheus-operator-crds
  ]
}

resource "kubernetes_config_map_v1" "stage" {
  metadata {
    name      = "stage"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
  data = {
    "STAGE" = "prod"
  }
}
