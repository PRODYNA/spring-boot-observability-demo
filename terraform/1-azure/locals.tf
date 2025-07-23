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
    petclinic = {
      repository = "etclinic"
      tag        = "3.0.1"
    }
    tracker = {
      repository = "tracker"
      tag        = "1.0.0"
    }
  }
}
