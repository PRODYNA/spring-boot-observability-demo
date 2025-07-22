resource "cloudflare_record" "prodyna-wtf" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  content = azurerm_public_ip.ingress.ip_address
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "grafana-prodyna-wtf" {
  zone_id = var.cloudflare_zone_id
  name    = "grafana.${var.project_name}"
  content = azurerm_public_ip.ingress.ip_address
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "person-prodyna-wtf" {
  zone_id = var.cloudflare_zone_id
  name    = "person.${var.project_name}"
  content = azurerm_public_ip.ingress.ip_address
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "petclinic-prodyna-wtf" {
  zone_id = var.cloudflare_zone_id
  name    = "petclinic.${var.project_name}"
  content = azurerm_public_ip.ingress.ip_address
  type    = "A"
  ttl     = 3600
}


resource "cloudflare_record" "tracker-prodyn-wtf" {
    zone_id = var.cloudflare_zone_id
    name    = "tracker.${var.project_name}"
    content = azurerm_public_ip.ingress.ip_address
    type    = "A"
    ttl     = 3600
}
