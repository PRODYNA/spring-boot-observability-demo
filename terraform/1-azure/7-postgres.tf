# random password for the postgresql server
resource "random_password" "psqladmin" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_flexible_server" "app" {
  name                          = "${var.project_name}-psql"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "12"
  public_network_access_enabled = true
  administrator_login           = "psqladmin"
  administrator_password        = random_password.psqladmin.result

  storage_mb   = 32768
  storage_tier = "P4"
  zone = "1"

  sku_name   = "B_Standard_B1ms"
}

# Database person
resource "azurerm_postgresql_flexible_server_database" "person" {
  name                = "person"
  server_id = azurerm_postgresql_flexible_server.app.id
}

locals {
  database = {
    person = {
      hostname = azurerm_postgresql_flexible_server.app.fqdn
      username = azurerm_postgresql_flexible_server.app.administrator_login
      password = random_password.psqladmin.result
    }
  }
}

# allow access from everythwere
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name                = "AllowAll"
  server_id = azurerm_postgresql_flexible_server.app.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}