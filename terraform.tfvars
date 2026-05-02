# Producer project (dev / default tfvars for CI plan).
# Bucket name must be globally unique — change suffix if creation fails.

project_id  = "sadaf-gcp-project-494415"
bucket_name = "sadaf-gcp-494415-sc-modules-audit-dev"
location    = "us-central1"

storage_class = "STANDARD"

labels = {
  environment = "dev"
  team        = "platform"
  managed_by  = "terraform"
  application = "service-catalogue"
  gcp_role    = "producer"
}

lifecycle_rules = [
  {
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                = 90
      with_state         = "ARCHIVED"
      num_newer_versions = 1
    }
  },
  {
    action = {
      type = "Delete"
    }
    condition = {
      age = 365
    }
  },
]

enable_apis = true
