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

RESTARGS="${@:2}"


function gatewayIP() {
  local gwname=$1
  terraform output -json gateways | jq -c '.[]' | while read -r gw; do
    local name=$(echo $gw | jq -r '.name')
    if [ "$name" == "$gwname" ]; then
      echo $(echo $gw | jq -r '.public_ip[0]')
      return
    fi
  done
  echo ""
}

IP_ADDRESS=$(gatewayIP $GW)
if [ -z "$IP_ADDRESS" ]; then
    echo "Gateway $GW not found in Terraform state."
    exit 1
fi


echo

echo "Trying SSH connection to ${IP_ADDRESS} with key ../secrets/gateways-keypair.pem "
REST_OF_ARGS="${@:2}"
# prevent checking fingerprint by use of /dev/null in -o UserKnownHostsFile=/dev/null
timeout 5 ssh -i ../secrets/gateways-keypair.pem  admin@"$IP_ADDRESS" -o StrictHostKeyChecking=no  -o UserKnownHostsFile=/dev/null fw stat
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
