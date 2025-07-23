resource "kubernetes_namespace" "tracker" {
  metadata {
    name = "tracker"
    annotations = {
      "telemetry.tenant" = "tracker"
    }
  }
}

resource "helm_release" "tracker" {
  chart     = "../../chart/person"
  name      = "tracker"
  namespace = kubernetes_namespace.tracker.metadata[0].name
  version   = "0.1.0"

  values = [
    file("helm/tracker.yaml"),
  ]

  set {
    name = "image.repository"
    value = data.terraform_remote_state.azure.outputs.app.tracker.image.name
  }

  set {
    name = "image.tag"
    value = data.terraform_remote_state.azure.outputs.app.tracker.image.tag
  }

  set {
    name  = "ingress.hosts[0].host"
    value = data.terraform_remote_state.azure.outputs.app.tracker.hostname
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.app.tracker.hostname
  }

}
