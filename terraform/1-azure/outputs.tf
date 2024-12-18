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

output "fq_image_name" {
  value = "${azurerm_container_registry.main.login_server}/${local.image.repository}"
}

output "image_tag" {
  value = local.image.tag
}

output "project_name" {
  value = var.project_name
}

output "app_name" {
  value = "${var.project_name}.prodyna.wtf"
}

output "grafana_name" {
  value = "grafana.${var.project_name}.prodyna.wtf"
}

output "database" {
  value = local.database
  sensitive = true
}
