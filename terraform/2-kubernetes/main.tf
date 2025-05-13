###############
## TERRAFORM ##
###############

terraform {
  required_providers {
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
