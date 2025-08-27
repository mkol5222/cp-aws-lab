#!/bin/bash

set -euo pipefail

INSTANCE_ID=$(cd ha-man; terraform output -raw id)

# if not provided, exit
if [ -z "$INSTANCE_ID" ]; then
  echo "Instance ID not provided. Exiting."
  exit 1
fi

# if no ~/.ssh/id_rsa.pub, fix it
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  echo "No SSH public key found at ~/.ssh/id_rsa.pub. Creating one."
  # echo "Generate one with: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''"
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''
  # exit 1
fi

# Copy the SSH public key to the instance
aws ec2-instance-connect send-serial-console-ssh-public-key \
    --instance-id "$INSTANCE_ID" \
    --serial-port 0 \
    --ssh-public-key file://~/.ssh/id_rsa.pub \
    --region eu-north-1 > /dev/null

# connect to serial console
aws ec2 enable-serial-console-access > /dev/null || true
# aws ec2 get-serial-console-access-status

echo "Connecting to the serial console of instance $INSTANCE_ID..."
echo "   Wait for console output to appear."
echo "Exit with Enter ~."
echo

ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa "${INSTANCE_ID}.port0@serial-console.ec2-instance-connect.eu-north-1.aws"