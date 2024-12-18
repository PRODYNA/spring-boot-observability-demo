locals {
  tags = {
    project    = var.project_name
    managed_by = "terraform"
  }
  resource_prefix = local.tags.project
  image = {
    repository = "person"
    tag        = "1.0.0"
  }
}
