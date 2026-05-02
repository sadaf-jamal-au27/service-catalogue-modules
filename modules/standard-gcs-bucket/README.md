# standard-gcs-bucket

Opinionated Google Cloud Storage bucket for org-standard data stores.

## Features

- Uniform bucket-level access (default: on)
- Versioning (default: on)
- Public access prevention (default: enforced)
- Optional CMEK
- Optional API enablement with `disable_on_destroy = false` on `google_project_service`

## Usage

```hcl
module "audit_bucket" {
  source = "./modules/standard-gcs-bucket"

  project_id = var.project_id
  name       = "my-org-audit-logs-prod"
  location   = "us-central1"

  labels = {
    team = "platform"
    env  = "prod"
  }
}
```

## Service Catalog packaging

Zip files at the **zip root** (not inside a nested folder):

```bash
cd modules/standard-gcs-bucket
zip -r ../../dist/standard-gcs-bucket-v1.0.0.zip .
```

Upload:

```bash
gsutil cp ../../dist/standard-gcs-bucket-v1.0.0.zip gs://YOUR_MODULE_BUCKET/releases/standard-gcs-bucket-v1.0.0.zip
```

In Service Catalog Admin, create a **Terraform config** solution and set **Link to Terraform config** to that `gs://` URI.

## Inputs

See `variables.tf`.

## Outputs

See `outputs.tf`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 6.0.0, < 7.0.0 |
