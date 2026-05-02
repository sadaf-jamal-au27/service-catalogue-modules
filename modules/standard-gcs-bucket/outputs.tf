output "bucket_name" {
  description = "Bucket name."
  value       = google_storage_bucket.this.name
}

output "bucket_self_link" {
  description = "Bucket self link."
  value       = google_storage_bucket.this.self_link
}

output "bucket_url" {
  description = "gs:// URL."
  value       = google_storage_bucket.this.url
}

output "bucket_location" {
  description = "Bucket location."
  value       = google_storage_bucket.this.location
}
