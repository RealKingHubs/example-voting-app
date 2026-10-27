#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

helm repo add eks https://aws.github.io/eks-charts > /dev/null 2>&1 || true
helm repo update eks > /dev/null

CHART_VERSION=$(helm show chart eks/aws-load-balancer-controller | awk '/^version:/ {print $2}' | tr -d '"')
APP_VERSION=$(helm show chart eks/aws-load-balancer-controller | awk '/^appVersion:/ {print $2}' | tr -d '"')
TAG="v${APP_VERSION#v}"

mkdir -p terraform/policies
curl -fsSL -o terraform/policies/lb-controller-iam-policy.json \
  "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${TAG}/docs/install/iam_policy.json"

echo "LBC_CHART_VERSION=${CHART_VERSION}" > scripts/versions.env
echo "Chart ${CHART_VERSION}, controller ${TAG}, policy saved."