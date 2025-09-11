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

GWIP=$(gatewayIP $GW)
if [ -z "$GWIP" ]; then
    echo "Gateway $GW not found in Terraform state."
    exit 1
fi

echo "Gateway $GW has public IP $GWIP"


 # if no ~/.ssh/id_rsa.pub, fix it
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  echo "No SSH public key found at ~/.ssh/id_rsa.pub. Creating one."
  # echo "Generate one with: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''"
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''
  # exit 1
fi

#shift gateway name away from "$@"



if [ -z "$RESTARGS" ]; then
  ssh -i ../secrets/gateways-keypair.pem -o StrictHostKeyChecking=no "admin@$GWIP" 
else
  ssh -i ../secrets/gateways-keypair.pem -o StrictHostKeyChecking=no "admin@$GWIP" $RESTARGS
fi
if [ $? -ne 0 ]; then
  echo "SSH connection failed. Please check your instance and network settings."
  exit 1
fi


