#!/usr/bin/env bash
set -euo pipefail

NS=voting
REGION=eu-north-1

echo "1. Removing the app (the controller deletes the load balancer)"
helm -n "$NS" uninstall voting || true

echo "2. Deleting the database claim (this deletes the EBS disk)"
kubectl -n "$NS" delete pvc --all --wait=true || true

echo "3. Waiting 90 seconds for AWS to remove the load balancer"
sleep 90

echo "4. Leftover check (every list below must be empty)"
echo "Load balancers:"
aws elbv2 describe-load-balancers --region "$REGION" \
  --query "LoadBalancers[].LoadBalancerName" --output text
echo "Unattached disks:"
aws ec2 describe-volumes --region "$REGION" \
  --filters Name=status,Values=available \
  --query "Volumes[].VolumeId" --output text
echo "Controller security groups:"
aws ec2 describe-security-groups --region "$REGION" \
  --filters Name=tag-key,Values=elbv2.k8s.aws/cluster \
  --query "SecurityGroups[].GroupId" --output text

echo "Now run: cd terraform && terraform destroy"