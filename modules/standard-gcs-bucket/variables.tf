variable "project_id" {
  description = "The GCP project ID where the bucket will be created."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid GCP project ID."
  }
}

variable "name" {
  description = "Globally unique bucket name (lowercase, DNS naming rules)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-.]{1,61}[a-z0-9]$", var.name))
    error_message = "Bucket name must comply with GCS naming rules."
  }
}

variable "location" {
  description = "Location for the bucket (region or multi-region), e.g. US, EU, us-central1."
  type        = string
}

variable "storage_class" {
  description = "Default storage class."
  type        = string
  default     = "STANDARD"

  validation {
    condition = contains([
      "STANDARD",
      "NEARLINE",
      "COLDLINE",
      "ARCHIVE",
    ], var.storage_class)
    error_message = "storage_class must be a supported GCS storage class."
  }
}

variable "enable_uniform_bucket_level_access" {
  description = "Enforce uniform bucket-level access (recommended)."
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Enable object versioning for data protection."
  type        = bool
  default     = true
}

variable "public_access_prevention" {
  description = "Public access prevention setting."
  type        = string
  default     = "enforced"

  validation {
    condition = contains([
      "enforced",
      "inherited",
    ], var.public_access_prevention)
    error_message = "public_access_prevention must be enforced or inherited."
  }
}

variable "labels" {
  description = "Labels applied to the bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = <<-EOT
    Optional lifecycle rules. Example:
    [{
      action = { type = "Delete" }
      condition = { age = 365 }
    }]
  EOT
  type        = any
  default     = []
}

variable "enable_apis" {
  description = "Whether to enable required Google APIs in the target project via google_project_service."
  type        = bool
  default     = true
}

variable "kms_key_name" {
  description = "Optional Cloud KMS key resource name for CMEK. Leave null for Google-managed encryption."
  type        = string
  default     = null
}
