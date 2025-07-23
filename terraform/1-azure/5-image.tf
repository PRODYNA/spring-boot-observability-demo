# Build container image insize of ACR
resource "terraform_data" "build_person" {
  provisioner "local-exec" {
    command = "az acr build -r ${azurerm_container_registry.main.name} --build-arg VERSION=${local.image.person.tag} -t ${local.image.person.repository}:${local.image.person.tag} ../../app/person -g ${azurerm_resource_group.main.name}"
  }
}

resource "terraform_data" "build_petclinic" {
  provisioner "local-exec" {
    command = "az acr build -r ${azurerm_container_registry.main.name} --build-arg VERSION=${local.image.petclinic.tag} -t ${local.image.petclinic.repository}:${local.image.petclinic.tag} ../../app/spring-petclinic -g ${azurerm_resource_group.main.name}"
  }
}

resource "terraform_data" "build_tracker" {
  provisioner "local-exec" {
    command = "az acr build -r ${azurerm_container_registry.main.name} --build-arg VERSION=${local.image.tracker.tag} -t ${local.image.tracker.repository}:${local.image.tracker.tag} ../../app/cargotracker -g ${azurerm_resource_group.main.name}"
  }
}
