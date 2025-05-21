resource "helm_release" "grafana" {
  chart      = "grafana"
  repository = local.helm.repository.grafana
  name       = "grafana"
  namespace  = kubernetes_namespace.observability.metadata[0].name
  version    = "9.0.0"

  values = [
    file("helm/grafana.yaml"),
  ]
  set {
      name  = "ingress.hosts[0]"
      value = data.terraform_remote_state.azure.outputs.grafana_hostname
    }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.grafana_hostname
  }

  depends_on = [
    helm_release.prometheus-operator-crds
  ]
}

resource "kubernetes_config_map_v1" "grafana-dashboard-worldmap" {
  metadata {
    name      = "grafana-dashboard-worldmap"
    namespace = kubernetes_namespace.observability.metadata[0].name
    labels = {
      "grafana_dashboard" = "1"
    }
  }
  data = {
      "worldmap.json" = file("dashboard/worldmap.yaml")
  }
}
