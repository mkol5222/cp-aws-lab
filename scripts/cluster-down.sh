#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

# Linux first
echo "LINUX down"
(cd cluster && terraform destroy -target module.linux -auto-approve)
# then cluster to this VPC
echo "CLUSTER down"
(cd cluster && terraform destroy -target module.cluster -auto-approve)
#  network
echo "NETWORK down"
(cd cluster && terraform destroy -target module.network -auto-approve)
# SSH keypair 
echo "SSH down"
(cd cluster && terraform destroy -target module.ssh -auto-approve)

# (cd cluster/; terraform state list | grep eni | while read R; do terraform destroy -target "$R" -auto-approve; done)

# (cd cluster && terraform destroy -auto-approve)

echo
echo "Remaining TF state:"
(cd cluster; terraform state list)
echo "__END__"