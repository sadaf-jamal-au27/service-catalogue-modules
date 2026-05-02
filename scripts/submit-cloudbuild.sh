#!/usr/bin/env bash
# Submit Cloud Build using a supported Python (avoids gcloud crash with Python 3.9).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for py in /opt/homebrew/bin/python3.12 /opt/homebrew/bin/python3.11 /usr/local/bin/python3.11; do
  if [[ -x "$py" ]]; then
    export CLOUDSDK_PYTHON="$py"
    break
  fi
done

exec gcloud builds submit --config=cloudbuild.yaml --project=sadaf-gcp-project-494415 "$ROOT"
