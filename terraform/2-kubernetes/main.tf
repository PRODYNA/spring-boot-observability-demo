###############
## TERRAFORM ##
###############

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
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

##############
## PROVIDER ##
##############

# setting up the connection to the AKS cluster
provider "kubernetes" {
}

provider "helm" {
  kubernetes {
  }
}

##################
## DATA SOURCES ##
##################

data "azurerm_client_config" "current" {}
