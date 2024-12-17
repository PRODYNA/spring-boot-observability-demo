resource "helm_release" "grafana" {
    chart      = "grafana"
    repository = local.helm.repository.grafana
    name       = "grafana"
    namespace  = kubernetes_namespace.observability.metadata[0].name
    version    = "8.8.2"

    values = [
        file("helm/grafana.yaml"),
    ]

    depends_on = [
        helm_release.prometheus-operator-crds
    ]
}