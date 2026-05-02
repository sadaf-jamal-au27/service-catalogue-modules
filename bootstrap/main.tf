data "google_project" "this" {
  project_id = var.project_id
}

locals {
  cloud_build_service_accounts = toset([
    "${data.google_project.this.number}@cloudbuild.gserviceaccount.com",
    "${data.google_project.this.number}-compute@developer.gserviceaccount.com",
  ])
}

resource "google_project_service" "storage" {
  count   = var.enable_apis ? 1 : 0
  project = var.project_id
  service = "storage.googleapis.com"

  disable_on_destroy = false
}

resource "google_storage_bucket" "module_artifacts" {
  name                        = var.artifact_bucket_name
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = {
    purpose     = "terraform-module-artifacts"
    service     = "service-catalog"
    environment = "shared"
  }

  depends_on = [google_project_service.storage]
}

resource "google_storage_bucket_iam_member" "cloud_build_publish" {
  for_each = local.cloud_build_service_accounts
  bucket   = google_storage_bucket.module_artifacts.name
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${each.value}"
}
