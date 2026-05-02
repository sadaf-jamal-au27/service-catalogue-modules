#!/usr/bin/env bash
# Cloud Build uploads sources to gs://PROJECT_ID_cloudbuild/; the service
# account that runs the build must be able to read those objects. If you see:
#   NUM-compute@developer.gserviceaccount.com does not have storage.objects.get
# run this once as a project Owner (or Storage Admin) on the producer project.
set -euo pipefail

PROJECT_ID="${1:-sadaf-gcp-project-494415}"
BUCKET="gs://${PROJECT_ID}_cloudbuild"
NUM="$(gcloud projects describe "${PROJECT_ID}" --format='value(projectNumber)')"

COMPUTE_SA="${NUM}-compute@developer.gserviceaccount.com"
CB_SA="${NUM}@cloudbuild.gserviceaccount.com"

echo "Project: ${PROJECT_ID} (number ${NUM})"
echo "Bucket:  ${BUCKET}"
echo "Granting roles/storage.objectViewer on the Cloud Build staging bucket to:"
echo "  - ${COMPUTE_SA}"
echo "  - ${CB_SA}"

for MEMBER in "serviceAccount:${COMPUTE_SA}" "serviceAccount:${CB_SA}"; do
  gcloud storage buckets add-iam-policy-binding "${BUCKET}" \
    --member="${MEMBER}" \
    --role="roles/storage.objectViewer" \
    --project="${PROJECT_ID}"
done

# Builds default to the Compute Engine service account; grant Cloud Logging write.
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${COMPUTE_SA}" \
  --role="roles/logging.logWriter"

echo "Done. Re-run: ./scripts/submit-cloudbuild.sh"
