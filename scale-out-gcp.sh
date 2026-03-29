#!/usr/bin/env bash
# Production: resize a Google Cloud managed instance group (MIG).
# Prerequisites: gcloud auth (user or service account), IAM roles that can update MIG.
#
# Required env:
#   GCP_MIG_NAME   — MIG name
#   GCP_ZONE       — e.g. us-central1-a
# Optional:
#   GCP_PROJECT    — if not set via gcloud config
#   GCP_DESIRED_SIZE — fixed size (if set, used as-is)
#   GCP_INCREMENT  — if "1" (default), set size to min(current+1, GCP_MAX_SIZE)
#   GCP_MAX_SIZE   — cap when incrementing (default 10)
set -euo pipefail

: "${GCP_MIG_NAME:?Set GCP_MIG_NAME}"
: "${GCP_ZONE:?Set GCP_ZONE}"

PROJECT_FLAG=()
if [[ -n "${GCP_PROJECT:-}" ]]; then
  PROJECT_FLAG=(--project="${GCP_PROJECT}")
fi

if [[ -n "${GCP_DESIRED_SIZE:-}" ]]; then
  SIZE="${GCP_DESIRED_SIZE}"
else
  if [[ "${GCP_INCREMENT:-1}" == "1" ]]; then
    CURRENT="$(gcloud compute instance-groups managed describe "${GCP_MIG_NAME}" \
      --zone="${GCP_ZONE}" "${PROJECT_FLAG[@]}" --format='value(targetSize)' 2>/dev/null || echo 0)"
    MAX="${GCP_MAX_SIZE:-10}"
    SIZE=$((CURRENT + 1))
    if (( SIZE > MAX )); then
      echo "scale-out-gcp: already at or above max (${MAX}), current=${CURRENT}" >&2
      exit 0
    fi
  else
    echo "Set GCP_DESIRED_SIZE or GCP_INCREMENT=1" >&2
    exit 1
  fi
fi

gcloud compute instance-groups managed resize "${GCP_MIG_NAME}" \
  --zone="${GCP_ZONE}" "${PROJECT_FLAG[@]}" --size="${SIZE}"

echo "scale-out-gcp: MIG ${GCP_MIG_NAME} zone=${GCP_ZONE} size=${SIZE}"
