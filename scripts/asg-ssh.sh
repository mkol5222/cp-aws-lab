#!/bin/bash

set -euo pipefail

# assume "1" when no argument
MEMBER="${1:-1}"


# look for running instance Named cluster-Member-A or cluster-Member-B
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=lab-asg_gw*" "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output json | jq --argjson N "$MEMBER" -r 'flatten | .[$N-1]')
# if not found, exit
if [ -z "$INSTANCE_ID" ]; then
  echo "Instance ID for lab-asg_gw ${MEMBER} not found. Exiting."
  exit 1
fi

echo "Instance ID for lab-asg_gw ${MEMBER}: $INSTANCE_ID"


# public IP if INSTANCE_ID
IP_ADDRESS=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output text)
if [ -z "$IP_ADDRESS" ]; then
  echo "Public IP address for instance $INSTANCE_ID not found. Exiting."
  exit 1
fi

REST_OF_ARGS="${@:2}"
ssh -i ./secrets/asg-keypair.pem admin@"$IP_ADDRESS" -o StrictHostKeyChecking=no "$REST_OF_ARGS"
if [ $? -ne 0 ]; then
  echo "SSH connection failed. Please check your instance and network settings."
  exit 1
fi
# echo "SSH connection established successfully."