output "bucket_name" {
  description = "Created bucket name."
  value       = module.standard_gcs_bucket.bucket_name
}

output "bucket_url" {
  description = "gs:// URL of the bucket."
  value       = module.standard_gcs_bucket.bucket_url
}

output "bucket_self_link" {
  value = module.standard_gcs_bucket.bucket_self_link
}

output "bucket_location" {
  value = module.standard_gcs_bucket.bucket_location
}
