resource "kubernetes_namespace" "person" {
  metadata {
    name = "person"
  }
}

resource "helm_release" "person" {
  chart      = "../../chart/person"
  name       = "person"
  namespace  = kubernetes_namespace.person.metadata[0].name
  version    = "0.1.0"

  values = [
      file("helm/person.yaml"),
  ]
}
