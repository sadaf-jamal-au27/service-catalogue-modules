output "artifact_bucket_name" {
  description = "GCS bucket name (no gs:// prefix)."
  value       = google_storage_bucket.module_artifacts.name
}

output "artifact_bucket_url" {
  description = "gs:// URL for module uploads."
  value       = google_storage_bucket.module_artifacts.url
}

output "publish_substitution_hint" {
  description = "Use this _ARTIFACT_BUCKET value in Cloud Build substitutions."
  value       = google_storage_bucket.module_artifacts.name
}
