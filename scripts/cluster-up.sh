#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

(cd cluster && terraform init)

# and SSH keypair for cluster and Linux VM
echo "SSH up"
(cd cluster && terraform apply -target=module.ssh -auto-approve)
# network 
echo "NETWORK up"
(cd cluster && terraform apply -target=module.network -auto-approve)
# then cluster to this VPC
echo "CLUSTER up"
(cd cluster && terraform apply -target=module.cluster -auto-approve)


# ENI cluster-Member_A_InternalInterface
CLUSTER_MEMBER_A_INTERNAL_ENI=$(aws ec2 describe-network-interfaces \
  --filters "Name=tag:Name,Values=cluster-Member_A_InternalInterface"  \
  --query "NetworkInterfaces[0].NetworkInterfaceId" \
  --output text)
echo "CLUSTER_MEMBER_A_INTERNAL_ENI: $CLUSTER_MEMBER_A_INTERNAL_ENI"

# Linux last
echo "LINUX up"
(cd cluster && terraform apply -var "internal_eni_id=$CLUSTER_MEMBER_A_INTERNAL_ENI" -target=module.linux -auto-approve)

echo
echo "OUTPUTS:"
(cd cluster && terraform output)
echo "DONE"