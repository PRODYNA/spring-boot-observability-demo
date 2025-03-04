resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

# https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert_manager" {
  repository       = local.helm.repository.jetstack
  chart            = "cert-manager"
  name             = "cert-manager"
  namespace        = kubernetes_namespace.cert-manager.metadata[0].name
  version          = "1.17.1"
  create_namespace = false
  force_update     = true

  values = [
    file("helm/cert-manager.yaml")
  ]

  depends_on = [
    helm_release.prometheus-operator-crds
  ]
}

resource "helm_release" "clusterissuer-traefik" {
  repository       = local.helm.repository.snowplow-devops
  chart            = "cert-manager-issuer"
  version          = "0.1.0"
  name             = "letsencrypt-traefik"
  namespace        = kubernetes_namespace.cert-manager.metadata[0].name
  create_namespace = false
  depends_on = [
    helm_release.cert_manager
  ]
  values = [
    file("helm/cert-manager-issuer-traefik.yaml")
  ]
}
