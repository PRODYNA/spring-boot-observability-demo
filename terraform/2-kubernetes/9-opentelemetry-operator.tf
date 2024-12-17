resource "helm_release" "opentelemetry-operator" {
    chart      = "opentelemetry-operator"
    repository = local.helm.repository.open-telemetry
    name       = "opentelemetry-operator"
    namespace  = kubernetes_namespace.observability.metadata[0].name
    version    = "0.75.1"

    values = [
        file("helm/opentelemetry-operator.yaml"),
    ]

    depends_on = [
        helm_release.prometheus-operator-crds
    ]
}