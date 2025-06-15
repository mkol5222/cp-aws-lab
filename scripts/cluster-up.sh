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
# Linux last
echo "LINUX up"
(cd cluster && terraform apply -target=module.linux -auto-approve)

echo
echo "OUTPUTS:"
(cd cluster && terraform output)
echo "DONE"