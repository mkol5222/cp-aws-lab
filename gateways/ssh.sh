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

export INSTANCE_ID=""
export PUBLIC_IP=""
export RESTARGS="${@:2}"

terraform output -json gateways | jq -c '.[]' | while read -r gw; do
  GW=$(echo $gw | jq -r '.name')
  export PUBLIC_IP=$(echo $gw | jq -r '.public_ip[0]')
  export INSTANCE_ID=$(echo $gw | jq -r '.id')
  if [ "$GW" == "$1" ]; then
        
    
  echo "$GW $PUBLIC_IP $INSTANCE_ID"

  # if no ~/.ssh/id_rsa.pub, fix it
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  echo "No SSH public key found at ~/.ssh/id_rsa.pub. Creating one."
  # echo "Generate one with: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''"
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''
  # exit 1
fi

#shift gateway name away from "$@"


echo "Connecting to the instance $INSTANCE_ID with public IP $PUBLIC_IP using SSH..."
ssh -t -i ../secrets/gateways-keypair.pem -o StrictHostKeyChecking=no "admin@$PUBLIC_IP" $RESTARGS
if [ $? -ne 0 ]; then
  echo "SSH connection failed. Please check your instance and network settings."
  exit 1
fi
break
fi

done


