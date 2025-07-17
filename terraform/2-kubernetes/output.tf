output "observability_namespace" {
  value = kubernetes_namespace.observability.metadata[0].name
}

output "grafana_secret_name" {
  value = helm_release.grafana.metadata[0].name
}

