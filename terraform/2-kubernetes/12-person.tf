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
    name = "image.repository"
    value = data.terraform_remote_state.azure.outputs.fq_image_name
  }

  set {
    name = "image.tag"
    value = data.terraform_remote_state.azure.outputs.image_tag
  }
  set {
    name  = "ingress.hosts[0].host"
    value = data.terraform_remote_state.azure.outputs.app_name
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.app_name
  }

  set {
    name = "properties.spring.datasource.url"
    value = data.terraform_remote_state.azure.outputs.database.person.hostname
  }

  set {
    name = "properties.spring.datasource.username"
    value = data.terraform_remote_state.azure.outputs.database.person.username
  }

  set {
    name = "properties.spring.datasource.password"
    value = data.terraform_remote_state.azure.outputs.database.person.password
  }
}
