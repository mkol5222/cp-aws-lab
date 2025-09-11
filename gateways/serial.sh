#!/bin/bash

set -euo pipefail

REGION="eu-north-1"

# first arg
GW=${1:-}
# if no arg, show usage
if [ -z "$GW" ]; then
  echo "Usage: $0 <gateway-name>"
  echo "Example: $0 gw1"
  exit 1
fi

./tfvars.sh

./tfvars.sh

terraform output -json gateways | jq -c '.[]' | while read -r gw; do
  GW=$(echo $gw | jq -r '.name')
  PUBLIC_IP=$(echo $gw | jq -r '.public_ip[0]')
  INSTANCE_ID=$(echo $gw | jq -r '.id')
    if [ "$GW" != "$1" ]; then
        continue
    fi
  echo "$GW $PUBLIC_IP $INSTANCE_ID"

  # if no ~/.ssh/id_rsa.pub, fix it
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  echo "No SSH public key found at ~/.ssh/id_rsa.pub. Creating one."
  # echo "Generate one with: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''"
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''
  # exit 1
fi

# Copy the SSH public key to the instance
echo "SSH key for serial console access copied to instance $INSTANCE_ID in region $REGION"

echo aws ec2-instance-connect send-serial-console-ssh-public-key \
    --instance-id "$INSTANCE_ID" \
    --serial-port 0 \
    --ssh-public-key file://~/.ssh/id_rsa.pub \
    --region $REGION > /dev/null

aws ec2-instance-connect send-serial-console-ssh-public-key \
    --instance-id "$INSTANCE_ID" \
    --serial-port 0 \
    --ssh-public-key file://~/.ssh/id_rsa.pub \
    --region $REGION > /dev/null

# connect to serial console
echo "Enabling serial console access in region $REGION..."
aws ec2 enable-serial-console-access > /dev/null || true
# aws ec2 get-serial-console-access-status

echo "Connecting to the serial console of instance $INSTANCE_ID..."
echo "   Wait for console output to appear."
echo "Exit with Enter ~."
echo

ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa "${INSTANCE_ID}.port0@serial-console.ec2-instance-connect.$REGION.aws"
done
