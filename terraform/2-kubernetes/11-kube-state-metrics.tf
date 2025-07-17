resource "helm_release" "kube-state-metrics" {
  namespace  = kubernetes_namespace.observability.metadata[0].name
  name       = "kube-state-metrics"
  chart      = "kube-state-metrics"
  repository = local.helm.repository.prometheus-community
  version    = "6.1.0"

  depends_on = [
    helm_release.prometheus-operator-crds
  ]

  values = [
    file("helm/kube-state-metrics.yaml"),
  ]
}
