resource "kubernetes_namespace" "petclinic" {
  metadata {
    name = "petclinic"
    annotations = {
      "telemetry.tenant" = "petclinic"
    }
  }
}

resource "helm_release" "petclinic" {
  chart     = "../../chart/person"
  name      = "petclinic"
  namespace = kubernetes_namespace.petclinic.metadata[0].name
  version   = "0.1.0"

  values = [
    file("helm/petclinic.yaml"),
  ]

  set {
    name = "image.repository"
    value = data.terraform_remote_state.azure.outputs.spring_petclinic_image_name
  }

  set {
    name = "image.tag"
    value = data.terraform_remote_state.azure.outputs.spring_petclinic_image_tag
  }

  set {
    name  = "ingress.hosts[0].host"
    value = data.terraform_remote_state.azure.outputs.petclinic_hostname
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = data.terraform_remote_state.azure.outputs.petclinic_hostname
  }

  set {
    name = "config.spring.datasource.url"
    value = "jdbc:postgresql://${data.terraform_remote_state.azure.outputs.database.person.hostname}:5432/petclinicdb"
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
