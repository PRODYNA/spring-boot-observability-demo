terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }
    grafana = {
        source  = "grafana/grafana"
        version = "3.25.8"
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.azure.outputs.kubernetes_cluster.kube_admin_config[0].host
  client_certificate     = base64decode(data.terraform_remote_state.azure.outputs.kubernetes_cluster.kube_admin_config[0].client_certificate)
  client_key             = base64decode(data.terraform_remote_state.azure.outputs.kubernetes_cluster.kube_admin_config[0].client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.azure.outputs.kubernetes_cluster.kube_admin_config[0].cluster_ca_certificate)
}

provider "grafana" {
    url      = "https://${data.terraform_remote_state.azure.outputs.grafana_hostname}"
    auth     = local.grafana_admin_credentials
}

data "terraform_remote_state" "azure" {
  backend = "local"

  config = {
    path = "../1-azure/terraform.tfstate"
  }
}

data "terraform_remote_state" "kubernetes" {
  backend = "local"

  config = {
    path = "../2-kubernetes/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = data.terraform_remote_state.azure.outputs.subscription_id
}

data "kubernetes_namespace" "grafana" {
    metadata {
        name = data.terraform_remote_state.kubernetes.outputs.observability_namespace
    }
}

data "kubernetes_secret" "grafana" {
  metadata {
    name      = data.terraform_remote_state.kubernetes.outputs.grafana_secret_name
    namespace = data.kubernetes_namespace.grafana.metadata[0].name
  }
}

// create a base64 encoded string with username and the password, seperated by a colon
locals {
  grafana_admin_credentials = "${data.kubernetes_secret.grafana.data["admin-user"]}:${data.kubernetes_secret.grafana.data["admin-password"]}"
}