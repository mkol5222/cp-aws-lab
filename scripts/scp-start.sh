#!/bin/bash

set -euo pipefail

# look for EC2 instance named standalone-cp
SCP_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=standalone-cp" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

# start it
aws ec2 start-instances --instance-ids $SCP_ID

SCP_STATE=$(aws ec2 describe-instances \
  --instance-ids $SCP_ID \
  --query "Reservations[].Instances[].State.Name" \
  --output text)
echo $SCP_STATE