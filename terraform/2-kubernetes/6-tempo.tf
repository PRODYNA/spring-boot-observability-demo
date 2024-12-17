resource "kubernetes_namespace" "tempo" {
  metadata {
    name = "tempo"
  }
}

resource "helm_release" "tempo" {
  chart      = "tempo-distributed"
  repository = local.helm.repository.grafana
  name       = "tempo"
  namespace  = kubernetes_namespace.tempo.metadata[0].name
  version    = "1.16.0"

  values = [
    file("helm/tempo-distributed.yaml"),
  ]

  depends_on = [
    helm_release.prometheus-operator-crds
  ]
}
