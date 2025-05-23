resource "kubernetes_namespace_v1" "pyroscope" {
  metadata {
    name = "observability-pyroscope"
  }
}

resource "helm_release" "pyroscope" {
  chart      = "pyroscope"
  repository = local.helm.repository.grafana
  name       = "pyroscope"
  namespace  = kubernetes_namespace_v1.pyroscope.metadata[0].name
  version    = "1.13.4"

  values = [
    file("helm/pyroscope.yaml"),
  ]

  depends_on = [
    helm_release.prometheus-operator-crds
  ]
}