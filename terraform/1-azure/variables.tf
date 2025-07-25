variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "germanywestcentral"
}

variable "project_name" {
  type = string
}

variable "cloudflare_zone_id" {
  type    = string
  default = "93c4d56b0f391d3d3baf00845877f42b" # should be in a secret
}

variable "cloudflare_api_token" {
  type    = string
  default = "tEPDh8f3LRqft9al_6ReJ_Zo0ENp7niGJM3YKEGm" # should be in a secret
}

variable "aks" {
  description = "aks properties"

  type = object({
    default_node_pool = object({
      vm_size   = string
      min_count = number
      max_count = number
    })
    user_node_pool = object({
      vm_size   = string
      min_count = number
      max_count = number
    })
    version = object({
      control_plane = string
      node_pool     = string
    })
  })
  default = {
    default_node_pool = {
      vm_size   = "Standard_B4s_v2"
      min_count = 1
      max_count = 4
    }

    user_node_pool = {
      vm_size   = "Standard_B2s_v2"
      min_count = 1
      max_count = 2
    }

    version = {
      control_plane = "1.30.12"
      node_pool     = "1.30.12"
    }
  }
}

variable "enable_ddos_protection" {
  description = "Enable DDoS protection on the AKS cluster Ingress IP"
  type        = bool
  default     = false
}
