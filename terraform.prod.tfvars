# Consumer project — use: terraform plan -var-file=terraform.prod.tfvars

project_id  = "app-project-487612"
bucket_name = "app-proj-487612-sc-modules-audit-prod"
location    = "us-central1"

storage_class = "STANDARD"

labels = {
  environment = "prod"
  team        = "platform"
  managed_by  = "terraform"
  application = "service-catalogue"
  gcp_role    = "consumer"
  cost_center = "engineering"
}

lifecycle_rules = [
  {
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                = 180
      with_state         = "ARCHIVED"
      num_newer_versions = 2
    }
  },
  {
    action = {
      type = "Delete"
    }
    condition = {
      age = 730
    }
  },
]

enable_apis = true
