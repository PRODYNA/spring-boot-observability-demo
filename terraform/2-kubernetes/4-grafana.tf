resource "helm_release" "grafana" {
    chart      = "grafana"
    repository = local.helm.repository.grafana
    name       = "grafana"
    namespace  = kubernetes_namespace.observability.metadata[0].name
    version    = "8.8.2"

    values = [
        file("helm/grafana.yaml"),
    ]

    set {
        name = "ingress.hosts[0]"
        value = data.terraform_remote_state.azure.outputs.grafana_name
    }

    set {
        name = "ingress.tls[0].hosts[0]"
        value = data.terraform_remote_state.azure.outputs.grafana_name
    }

    depends_on = [
        helm_release.prometheus-operator-crds
    ]
}