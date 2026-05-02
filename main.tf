module "standard_gcs_bucket" {
  source = "./modules/standard-gcs-bucket"

  project_id = var.project_id
  name       = var.bucket_name
  location   = var.location

  storage_class                      = var.storage_class
  enable_uniform_bucket_level_access = var.enable_uniform_bucket_level_access
  enable_versioning                  = var.enable_versioning
  public_access_prevention           = var.public_access_prevention
  labels                             = var.labels
  lifecycle_rules                    = var.lifecycle_rules
  enable_apis                        = var.enable_apis
  kms_key_name                       = var.kms_key_name
}
