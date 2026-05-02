variable "project_id" {
  description = "Producer project that hosts the module artifact bucket."
  type        = string
}

variable "artifact_bucket_name" {
  description = "Globally unique GCS bucket name for Service Catalog Terraform zips."
  type        = string
}

variable "region" {
  description = "Bucket location."
  type        = string
  default     = "us-central1"
}

variable "enable_apis" {
  description = "Enable storage.googleapis.com in the project."
  type        = bool
  default     = true
}
