resource "kubernetes_namespace" "person" {
  metadata {
    name = "person"
  }
}

resource "helm_release" "person" {
  chart     = "../../chart/person"
  name      = "person"
  namespace = kubernetes_namespace.person.metadata[0].name
  version   = "0.1.0"

  values = [
    file("helm/person.yaml"),
  ]

  set {
    name  = "ingress.hosts[0].host"
    value = data.terraform_remote_state.azure.outputs.app_name
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.app_name
  }
}
