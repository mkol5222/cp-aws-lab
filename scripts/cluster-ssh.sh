#!/bin/bash

set -euo pipefail

# assume "A" when no argument
MEMBER="${1:-a}"

IP_OUTPUT_NAME="ip_${MEMBER}"
IP_ADDRESS=$(cd cluster; terraform output -raw "$IP_OUTPUT_NAME")
if [ -z "$IP_ADDRESS" ]; then
  echo "No public IP address found for member $MEMBER. Exiting."
  exit 1
fi

echo "Using member: $MEMBER ${IP_OUTPUT_NAME} ${IP_ADDRESS}"
echo

REST_OF_ARGS="${@:2}"
ssh -i ./secrets/cluster-keypair.pem admin@"$IP_ADDRESS" -o StrictHostKeyChecking=no "$REST_OF_ARGS"
if [ $? -ne 0 ]; then
  echo "SSH connection failed. Please check your instance and network settings."
  exit 1
fi
# echo "SSH connection established successfully."