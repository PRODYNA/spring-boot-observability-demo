locals {
  tags = {
    project    = var.project_name
    managed_by = "terraform"
  }
  resource_prefix = local.tags.project
  image = {
    person = {
      repository = "person"
      tag        = "1.0.0"
  },
    spring_petclinic = {
      repository = "spring-petclinic"
      tag        = "3.0.0"
    }
  }
}

