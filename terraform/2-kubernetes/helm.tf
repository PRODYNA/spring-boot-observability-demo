
locals {
  # A list of helm repositories
  helm = {
    repository = {
      bitnami              = "https://charts.bitnami.com/bitnami"
      dapr                 = "https://dapr.github.io/helm-charts/"
      equinor              = "https://equinor.github.io/helm-charts/charts"
      influxdata           = "https://helm.influxdata.com/"
      ingress-nginx        = "https://kubernetes.github.io/ingress-nginx"
      jaeger               = "https://jaegertracing.github.io/helm-charts"
      jetstack             = "https://charts.jetstack.io"
      kurt108              = "https://kurt108.github.io/helm-charts"
      open-telemetry       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
      prometheus-community = "https://prometheus-community.github.io/helm-charts"
      grafana              = "https://grafana.github.io/helm-charts"
      neo4j                = "https://helm.neo4j.com/neo4j"
      kubereboot           = "https://kubereboot.github.io/charts/"
      traefik              = "https://helm.traefik.io/traefik"
      rlex                 = "https://rlex.github.io/helm-charts/"
      kiwigrid             = "https://kiwigrid.github.io"
      snowplow-devops      = "https://snowplow-devops.github.io/helm-charts"
    }
  }
}
