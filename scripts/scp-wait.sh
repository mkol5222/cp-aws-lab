#!/bin/bash

set -euo pipefail

# look for EC2 instance named standalone-cp
SCP_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=standalone-cp" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -z "${SCP_ID:-}" ]; then
  echo "No instance found with tag Name=standalone-cp"
  exit 1
fi

SCP_STATE=$(aws ec2 describe-instances \
  --instance-ids "$SCP_ID" \
  --query "Reservations[].Instances[].State.Name" \
  --output text)
echo "Instance state: $SCP_STATE"

if [ "$SCP_STATE" = "stopped" ]; then
  echo "Instance is stopped. Start it first."
  exit 0
fi

if [ "$SCP_STATE" != "running" ]; then
  echo "Instance is not running."
  exit 0
fi

SCP_IP=$(aws ec2 describe-instances \
  --instance-ids "$SCP_ID" \
  --query "Reservations[].Instances[].PublicIpAddress" \
  --output text)

if [ -z "${SCP_IP:-}" ]; then
  echo "Instance has no public IP yet."
  exit 1
fi

echo "Waiting for SSH on $SCP_IP ..."

# loop until SSH works
while true; do
  if timeout 3 ssh -o BatchMode=yes -o ConnectTimeout=3 -o StrictHostKeyChecking=no -q "admin@$SCP_IP" hostname -i > /dev/null 2>&1; then
    echo "SSH connection successful."
    break
  fi
  echo "SSH connection failed; retrying in 5s..."
  sleep 5
done