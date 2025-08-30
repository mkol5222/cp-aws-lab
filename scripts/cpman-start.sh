#!/bin/bash

set -euo pipefail

# look for EC2 instance named cpman
NAME="cpman"

SCP_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$NAME" "Name=instance-state-name,Values=stopped" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

# stop it
aws ec2 start-instances --instance-ids $SCP_ID

SCP_STATE=$(aws ec2 describe-instances \
  --instance-ids $SCP_ID \
  --query "Reservations[].Instances[].State.Name" \
  --output text)
echo $SCP_STATE