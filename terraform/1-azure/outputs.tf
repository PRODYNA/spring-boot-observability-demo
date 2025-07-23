output "resource_group" {
  value = azurerm_resource_group.main
}

output "kubernetes_cluster" {
  value     = azurerm_kubernetes_cluster.main
  sensitive = true
}

output "container_registry" {
  value     = azurerm_container_registry.main
  sensitive = true
}

output "traefik_ip" {
  value = azurerm_public_ip.ingress
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

# output "resource_group_name" {
#   value = data.azurerm_resource_group.main.name
# }

output "project_name" {
  value = var.project_name
}

output "app_name" {
  value = "${var.project_name}.prodyna.wtf"
}

output "database" {
  value = local.database
  sensitive = true
}

output "app" {
  value = {
    grafana = {
      hostname = cloudflare_record.grafana-prodyna-wtf.hostname
    },
    petclinic = {
      hostname = cloudflare_record.petclinic-prodyna-wtf.hostname
      image = {
        name = "${azurerm_container_registry.main.login_server}/${local.image.petclinic.repository}"
        tag  = local.image.petclinic.tag
      }
    },
    person = {
      hostname = cloudflare_record.person-prodyna-wtf.hostname
      image = {
        name = "${azurerm_container_registry.main.login_server}/${local.image.person.repository}"
        tag  = local.image.person.tag
      }
    },
    tracker = {
      hostname = cloudflare_record.tracker-prodyna-wtf.hostname
      image = {
        name = "${azurerm_container_registry.main.login_server}/${local.image.tracker.repository}"
        tag  = local.image.tracker.tag
      }
    }
  }
}