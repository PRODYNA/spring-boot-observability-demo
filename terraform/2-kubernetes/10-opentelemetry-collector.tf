resource "kubernetes_cluster_role" "opentelemetry-collector" {
  metadata {
    name = "opentelemetry-collector"
  }
  rule {
    api_groups = [""]
    resources = ["configmaps", "persistentvolumeclaims", "persistentvolumes", "pods", "serviceaccounts",
    "services", "endpoints", "resourcequotas", "replicationcontrollers", "replicationcontrollers/status"]
    verbs = ["create", "delete", "get", "list", "watch", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["daemonsets", "deployments", "statefulsets"]
    verbs      = ["create", "delete", "get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["apps", "extensions"]
    resources  = ["replicasets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["create", "delete", "get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterroles", "clusterrolebindings"]
    verbs      = ["create", "delete", "get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/metrics", "nodes/stats", "nodes/proxy", "namespaces", "namespaces/status"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["events.k8s.io"]
    resources  = ["events"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["config.openshift.io"]
    resources  = ["infrastructures", "infrastructures/status"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "get", "list", "update"]
  }

  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["podmonitors", "servicemonitors"]
    verbs      = ["create", "delete", "get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["create", "delete", "get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["instrumentations"]
    verbs      = ["get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["opampbridges"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["opampbridges/finalizers"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["opampbridges/status"]
    verbs      = ["get", "patch", "update"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["opentelemetrycollectors"]
    verbs      = ["get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["opentelemetrycollectors/finalizers"]
    verbs      = ["get", "patch", "update"]
  }

  rule {
    api_groups = ["opentelemetry.io"]
    resources  = ["opentelemetrycollectors/status"]
    verbs      = ["get", "patch", "update"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = ["route.openshift.io"]
    resources  = ["routes", "routes/custom-host"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "opentelemetry-collector" {
  metadata {
    name = "opentelemetry-collector"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.opentelemetry-collector.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "opentelemetry-operator"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "opentelemetry-collector"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "opentelemetry-singly-collector"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "opentelemetry-targetallocator"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
}

# Add Service for CoreDNS
resource "kubernetes_manifest" "coredns-service" {
  manifest = yamldecode(file("manifest/coredns-service.yaml"))
}

# Add ServiceMonitor for CoreDNS
resource "kubernetes_manifest" "coredns-servicemonitor" {
  manifest = yamldecode(file("manifest/coredns-servicemonitor.yaml"))
}

resource "kubernetes_persistent_volume_claim_v1" "geoip" {
  metadata {
    name      = "geoip"
    namespace = kubernetes_namespace.observability.metadata[0].name
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "azurefile"
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "helm_release" "opentelemetry-collector" {
  namespace  = kubernetes_namespace.observability.metadata[0].name
  name       = "opentelemetry-collector"
  chart      = "any-resource"
  version    = "0.1.0"
  repository = local.helm.repository.kiwigrid

  depends_on = [
    helm_release.opentelemetry-operator
  ]

  values = [
    yamlencode({
      "anyResources" = {
        "config" = file("manifest/opentelemetry-collector.yaml")
      }
    })
  ]
}

resource "helm_release" "opentelemetry-collector-singly" {
  namespace  = kubernetes_namespace.observability.metadata[0].name
  name       = "opentelemetry-collector-singly"
  chart      = "any-resource"
  version    = "0.1.0"
  repository = local.helm.repository.kiwigrid

  depends_on = [
    helm_release.opentelemetry-operator
  ]

  values = [
    yamlencode({
      "anyResources" = {
        "config" = file("manifest/opentelemetry-collector-singly.yaml")
      }
    })
  ]
}