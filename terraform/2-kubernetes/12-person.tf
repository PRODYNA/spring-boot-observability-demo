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
    value = data.terraform_remote_state.azure.outputs.person_image_name
  }

  set {
    name = "image.tag"
    value = data.terraform_remote_state.azure.outputs.person_image_tag
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
    name = "config.spring.datasource.url"
    value = "jdbc:postgresql://${data.terraform_remote_state.azure.outputs.database.person.hostname}:5432/persondb"
  }

  set {
    name = "config.spring.datasource.username"
    value = data.terraform_remote_state.azure.outputs.database.person.username
  }

  set {
    name = "config.spring.datasource.password"
    value = data.terraform_remote_state.azure.outputs.database.person.password
  }
}

/*
resource "helm_release" "personai" {
  chart     = "../../chart/person"
  name      = "personai"
  namespace = kubernetes_namespace.person.metadata[0].name
  version   = "0.1.0"

  values = [
    file("helm/personai.yaml"),
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
    name = "config.spring.datasource.url"
    value = "jdbc:postgresql://${data.terraform_remote_state.azure.outputs.database.person.hostname}:5432/persondb"
  }

  set {
    name = "config.spring.datasource.username"
    value = data.terraform_remote_state.azure.outputs.database.person.username
  }

  set {
    name = "config.spring.datasource.password"
    value = data.terraform_remote_state.azure.outputs.database.person.password
  }
}
*/