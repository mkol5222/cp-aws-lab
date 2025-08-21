#!/bin/bash

set -euo pipefail

#INSTANCE_ID=$(cd management; terraform output -raw id)
#CPMANIP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
CPMANIP=$(cd standalone; terraform output -raw ip)
export CHECKPOINT_SESSION_NAME="TF $(whoami) $(date) from $(hostname)"
export CHECKPOINT_SESSION_DESCRIPTION="Terraform session description"

PARENTDIR=/workspaces/cp-aws-lab
# CPMANRG=$(cd "$PARENTDIR/management/" && terraform output -raw rg)
# CPMANNAME=$(cd "$PARENTDIR/management/" && terraform output -raw name)
# CPMANIP=$(az vm show -d --resource-group "$CPMANRG" --name "$CPMANNAME" --query "publicIps" -o tsv)
# CPMANIP=$(az vm show -d --resource-group "$CPMANRG" --name "$CPMANNAME" --query "publicIps" -o tsv)
# CPMANPASS=$(cd "$PARENTDIR/management/terraform"; terraform output -raw password)
CPMANPASS="Welcome@Home#1984"
# echo "Management IP: $CPMANIP   Password: $CPMANPASS"

export CHECKPOINT_SERVER="$CPMANIP"
export CHECKPOINT_USERNAME="admin"
export CHECKPOINT_PASSWORD="$CPMANPASS"
export CHECKPOINT_API_KEY=""

echo
echo "Policy for standalone instance: $CPMANIP"
echo

(cd policy/; terraform init)
(cd policy/; rm sid.json || true)
(cd policy/; terraform init)
if (cd policy/; terraform apply -auto-approve); then 
	echo "Terraform apply succeeded";
    export SID=$(cd policy/; jq -r .sid ./sid.json)
	./scripts/publish.sh "$SID"; 
else
    echo "Terraform apply failed";
    export SID=$(cd policy/; jq -r .sid ./sid.json)
	./scripts/discard.sh "$SID"; 
fi
echo "Policy: Done."
