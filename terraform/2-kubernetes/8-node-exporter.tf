resource "helm_release" "prometheus-node-exporter" {
  namespace  = kubernetes_namespace.observability.metadata[0].name
  name       = "prometheus-node-exporter"
  chart      = "prometheus-node-exporter"
  repository = local.helm.repository.prometheus-community
  version    = "4.46.0"
  depends_on = [
    helm_release.prometheus-operator-crds
  ]
  values = [
    file("helm/prometheus-node-exporter.yaml"),
  ]
}
