resource "kubernetes_namespace" "mimir" {
  metadata {
    name = "observability-mimir"
  }
}

resource "helm_release" "mimir" {
  chart      = "mimir-distributed"
  repository = local.helm.repository.grafana
  name       = "mimir"
  namespace  = kubernetes_namespace.mimir.metadata[0].name
  version    = "5.6.0"

  values = [
    file("helm/mimir.yaml"),
  ]

  # depends_on = [
  #   helm_release.prometheus-operator-crds
  # ]
}