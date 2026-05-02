# service-catalogue-modules

Reusable Terraform for **Google Cloud Service Catalog**–style workflows: a **standardized GCS bucket** module plus a root stack for producer/consumer projects.

## Projects

| Role     | Project ID                 |
|----------|----------------------------|
| Producer | `sadaf-gcp-project-494415` |
| Consumer | `app-project-487612`       |

## Layout

- `modules/standard-gcs-bucket/` — portable module (zip root for Service Catalog)
- Root `*.tf` — example composition; defaults in `terraform.tfvars` / `terraform.prod.tfvars`

## Cloud Build

### gcloud + Python on macOS

If `gcloud builds submit` crashes with `unsupported operand type(s) for |`, point gcloud at Python **3.10+**:

```bash
export CLOUDSDK_PYTHON="$(command -v python3.11 || command -v python3.12)"
```

Or run:

```bash
chmod +x scripts/submit-cloudbuild.sh
./scripts/submit-cloudbuild.sh
```

### IAM to submit builds

Your Google account must be able to create builds and upload source to the staging bucket. A project owner can grant (replace the email):

```bash
gcloud projects add-iam-policy-binding sadaf-gcp-project-494415 \
  --member="user:YOUR_EMAIL@gmail.com" \
  --role="roles/cloudbuild.builds.editor"

gcloud projects add-iam-policy-binding sadaf-gcp-project-494415 \
  --member="user:YOUR_EMAIL@gmail.com" \
  --role="roles/storage.objectAdmin"
```

Then:

```bash
gcloud builds submit --config=cloudbuild.yaml --project=sadaf-gcp-project-494415 .
```

Connect [https://github.com/sadaf-jamal-au27/service-catalogue-modules](https://github.com/sadaf-jamal-au27/service-catalogue-modules) in **Cloud Build → Repositories / Triggers** to run `cloudbuild.yaml` on push.

## Local

```bash
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
