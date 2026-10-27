#!/usr/bin/env bash
set -euo pipefail

echo "Starting Vote Scan....."
bash scripts/scan.sh vote

echo "Starting Result Scan......"
bash scripts/scan.sh result

echo "Starting worker scan...."
bash scripts/scan.sh worker