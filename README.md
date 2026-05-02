# service-catalogue-modules

Reusable Terraform for **Google Cloud Service Catalog**–style workflows: a **standardized GCS bucket** module plus a root stack for producer/consumer projects.

## Projects

| Role     | Project ID                 |
|----------|----------------------------|
| Producer | `sadaf-gcp-project-494415` |
| Consumer | `app-project-487612`       |

## Layout

- `modules/standard-gcs-bucket/` — portable module (zip root for Service Catalog)
- `bootstrap/` — producer **artifact bucket** + IAM so Cloud Build can upload module zips
- Root `*.tf` — example composition; defaults in `terraform.tfvars` / `terraform.prod.tfvars`

## Stage 2 — Module artifact bucket + publish (Service Catalog prep)

1. **Create the bucket and IAM** (once per producer project):

   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```

   This creates `gs://sadaf-gcp-494415-tf-catalog-modules` (see `bootstrap/terraform.tfvars`) with **versioning**, **UBLA**, and **`roles/storage.objectAdmin`** for the Cloud Build and default Compute service accounts.

2. **Run CI and upload the module zip** to `gs://<bucket>/releases/`:

   ```bash
   ./scripts/submit-cloudbuild.sh --publish
   ```

   Or keep CI-only (no upload): `./scripts/submit-cloudbuild.sh`

   Override the bucket name if you changed it in bootstrap:

   ```bash
   gcloud builds submit --config=cloudbuild.yaml --project=sadaf-gcp-project-494415 \
     --substitutions=_PUBLISH_MODULE=true,_ARTIFACT_BUCKET=YOUR_BUCKET \
     .
   ```

3. **Register in Google Cloud Service Catalog** (console): **Service Catalog Admin → Solutions → Create solution → Create Terraform config**. Set **Link to Terraform config** to the object from step 2, e.g. `gs://sadaf-gcp-494415-tf-catalog-modules/releases/standard-gcs-bucket-build-….zip`, pin a **Terraform version**, then assign the solution to a **catalog** and **share** the catalog with your consumer folder/project (`app-project-487612`, etc.). Official flow: [Creating a Terraform configuration](https://cloud.google.com/service-catalog/docs/terraform-configuration).

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
