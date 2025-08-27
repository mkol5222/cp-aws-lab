#!/bin/bash

set -euo pipefail

INSTANCE_ID=$(cd ha-man; terraform output -raw id)

# if not provided, exit
if [ -z "$INSTANCE_ID" ]; then
  echo "Instance ID not provided. Exiting."
  exit 1
fi

# if no ~/.ssh/id_rsa.pub, exit
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  echo "No SSH public key found at ~/.ssh/id_rsa.pub. Exiting."
  exit 1
fi

#
# aws ec2-instance-connect ssh \
#   --instance-id "$INSTANCE_ID" \
#   --os-user admin \
#   --region eu-north-1

ssh -i ./secrets/cpman-keypair-secondary.pem admin@"$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)" -o StrictHostKeyChecking=no "$@"
if [ $? -ne 0 ]; then
  echo "SSH connection failed. Please check your instance and network settings."
  exit 1
fi
# echo "SSH connection established successfully."