#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/versions.env

CLUSTER=voting-app-eks
REGION=eu-north-1
VPC_ID=$(aws ec2 describe-vpcs --region "$REGION" \
  --filters Name=is-default,Values=true \
  --query 'Vpcs[0].VpcId' --output text)

helm repo add eks https://aws.github.io/eks-charts > /dev/null 2>&1 || true
helm repo update eks > /dev/null

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --version "$LBC_CHART_VERSION" \
  --set clusterName="$CLUSTER" \
  --set region="$REGION" \
  --set vpcId="$VPC_ID" \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --wait --timeout 5m