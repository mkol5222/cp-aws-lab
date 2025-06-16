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

echo "Trying SSH connection to ${IP_ADDRESS} with key ./secrets/cluster-keypair.pem"
REST_OF_ARGS="${@:2}"
ssh -i ./secrets/cluster-keypair.pem admin@"$IP_ADDRESS" -o StrictHostKeyChecking=no fw stat
if [ $? -ne 0 ]; then
  echo "SSH connection failed. Please check your instance and network settings."
  exit 1
fi
# echo "SSH connection established successfully."

# wait for port to be open
function wait_for_port() {
    local ip=$1
    local port=$2
    while ! timeout 5 bash -c "</dev/tcp/$ip/$port"; do
        echo "Waiting for $ip:$port to be open..."
        sleep 5
    done
    echo "$ip:$port is now open. Ready to proceed."
}
wait_for_port "${IP_ADDRESS}" "18211"
