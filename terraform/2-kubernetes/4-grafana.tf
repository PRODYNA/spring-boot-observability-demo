resource "helm_release" "grafana-operator" {
  chart      = "grafana-operator"
  repository = local.helm.repository.grafana
  name       = "grafana-operator"
  namespace  = kubernetes_namespace.observability.metadata[0].name
  version    = "5.18.0"
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  repository = local.helm.repository.grafana
  name       = "grafana"
  namespace  = kubernetes_namespace.observability.metadata[0].name
  version    = "9.2.10"

  values = [
    file("helm/grafana.yaml"),
  ]
  set {
      name  = "ingress.hosts[0]"
      value = data.terraform_remote_state.azure.outputs.app.grafana.hostname
    }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.app.grafana.hostname
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
