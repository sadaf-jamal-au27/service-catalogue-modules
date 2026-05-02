variable "project_id" {
  description = "GCP project where the standardized bucket is created."
  type        = string
}

variable "bucket_name" {
  description = "Globally unique GCS bucket name."
  type        = string
}

variable "location" {
  description = "Bucket location (region or multi-region)."
  type        = string
}

variable "storage_class" {
  description = "Default storage class."
  type        = string
  default     = "STANDARD"
}

variable "enable_uniform_bucket_level_access" {
  type    = bool
  default = true
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "public_access_prevention" {
  type    = string
  default = "enforced"
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "lifecycle_rules" {
  description = "Optional lifecycle rules passed to the module."
  type        = any
  default     = []
}

variable "enable_apis" {
  type    = bool
  default = true
}

variable "kms_key_name" {
  description = "Optional CMEK key resource name."
  type        = string
  default     = null
}
