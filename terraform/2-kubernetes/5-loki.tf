resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }
}

resource "helm_release" "loki" {
    chart      = "loki"
    repository = local.helm.repository.grafana
    name       = "loki"
    namespace  = kubernetes_namespace.loki.metadata[0].name
    version    = "6.27.0"

    values = [
        file("helm/loki.yaml"),
    ]

    depends_on = [
        helm_release.prometheus-operator-crds
    ]
}
