resource "kubernetes_namespace" "mimir" {
  metadata {
    name = "mimir"
  }
}

resource "helm_release" "mimir" {
  chart      = "mimir-distributed"
  repository = local.helm.repository.grafana
  name       = "mimir"
  namespace  = kubernetes_namespace.mimir.metadata[0].name
  version    = "5.5.1"

  values = [
    file("helm/mimir.yaml"),
  ]

  depends_on = [
    helm_release.prometheus-operator-crds
  ]
}