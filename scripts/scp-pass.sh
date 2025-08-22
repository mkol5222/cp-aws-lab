#!/bin/bash

set -euo pipefail

INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=standalone-cp" "Name=instance-state-name,Values=pending,running,stopping,stopped,shutting-down" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

# if not provided, exit
if [ -z "$INSTANCE_ID" ]; then
  echo "Instance ID not provided. Exiting."
  exit 1
fi

# ip address
IP_ADDRESS=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
if [ -z "$IP_ADDRESS" ]; then
  echo "No public IP address found for instance $INSTANCE_ID. Exiting."
  exit 1
fi

CPMAN_PASS="Welcome@Home#1984"
echo "CPMAN IP is: $IP_ADDRESS"
echo "   login as admin / $CPMAN_PASS"