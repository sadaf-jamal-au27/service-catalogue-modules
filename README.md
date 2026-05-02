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

Manual run (producer):

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
