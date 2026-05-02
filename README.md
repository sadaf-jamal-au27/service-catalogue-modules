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

### Error: `compute@developer.gserviceaccount.com` / `storage.objects.get` denied

After `gcloud builds submit` uploads to `gs://PROJECT_ID_cloudbuild/`, Cloud Build reads that object using your project’s **default Compute Engine service account** (and/or the **Cloud Build service account**). If that bucket was created under tight defaults or org policy, those accounts may lack **objectViewer** on the staging bucket.

**Fix (run once as project Owner / Storage Admin):**

```bash
chmod +x scripts/fix-cloudbuild-source-bucket-iam.sh
./scripts/fix-cloudbuild-source-bucket-iam.sh sadaf-gcp-project-494415
```

Or manually (replace `345292937268` with your project number from **IAM & Admin → Settings** if it differs):

```bash
gcloud storage buckets add-iam-policy-binding gs://sadaf-gcp-project-494415_cloudbuild \
  --member="serviceAccount:345292937268-compute@developer.gserviceaccount.com" \
  --role="roles/storage.objectViewer"

gcloud storage buckets add-iam-policy-binding gs://sadaf-gcp-project-494415_cloudbuild \
  --member="serviceAccount:345292937268@cloudbuild.gserviceaccount.com" \
  --role="roles/storage.objectViewer"
```

The script also grants **`roles/logging.logWriter`** on the project to the default Compute SA so build logs can stream to Cloud Logging (optional if you only use GCS logs).

Then run `./scripts/submit-cloudbuild.sh` again.

## Local

```bash
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
