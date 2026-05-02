locals {
  services = [
    "storage.googleapis.com",
  ]
}

resource "google_project_service" "enabled" {
  for_each = var.enable_apis ? toset(local.services) : toset([])

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

resource "google_storage_bucket" "this" {
  name     = var.name
  project  = var.project_id
  location = var.location

  storage_class               = var.storage_class
  uniform_bucket_level_access = var.enable_uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention
  force_destroy               = false

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "encryption" {
    for_each = var.kms_key_name == null ? [] : [var.kms_key_name]
    content {
      default_kms_key_name = encryption.value
    }
  }

  labels = var.labels

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = try(lifecycle_rule.value.action.storage_class, null)
      }
      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)
        created_before             = try(lifecycle_rule.value.condition.created_before, null)
        with_state                 = try(lifecycle_rule.value.condition.with_state, null)
        matches_storage_class      = try(lifecycle_rule.value.condition.matches_storage_class, null)
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null)
      }
    }
  }

  depends_on = [google_project_service.enabled]
}
