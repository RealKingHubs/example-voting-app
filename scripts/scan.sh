#!/usr/bin/env bash
set -euo pipefail

SERVICE="${1:?usage: bash scripts/scan.sh vote|result|worker}"

docker build -t "${SERVICE}:test" "./${SERVICE}"

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "${HOME}/.cache/trivy:/root/.cache/trivy" \
  ghcr.io/aquasecurity/trivy:0.69.2 image \
  --skip-version-check \
  --no-progress \
  --severity HIGH,CRITICAL \
  --ignore-unfixed \
  --exit-code 1 \
  "${SERVICE}:test"