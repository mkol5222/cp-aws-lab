#!/bin/bash

set -euo pipefail

source ./tfvars.sh

terraform init

terraform apply -auto-approve -target local_file.private_key

#GWS=$(terraform output -json gw_names | jq -r '.[]')
GWS=$(echo gw1 gw2)
echo $GWS

for G in $GWS; do
  echo "Applying resources for gateway $G ..."
  terraform apply "-target=module.gw[\"$G\"].aws_route_table.private_subnet_rtb" -auto-approve 
done

terraform apply -auto-approve

