#!/bin/bash

set -euo pipefail

(cd asg || exit 1)

(cd asg && terraform init)

# and SSH keypair for cluster and Linux VM
echo "SSH up"
(cd asg && terraform apply -target=module.ssh -auto-approve)
# network 
echo "NETWORK up"
(cd asg && terraform apply -target=module.network -auto-approve)
# then cluster to this VPC
echo "ASG up"
(cd asg && terraform apply -target=module.asg -auto-approve)


# Linux last
echo "LINUX up"
(cd asg && terraform apply  -target=module.linux -auto-approve)

echo
echo "OUTPUTS:"
(cd asg && terraform output)
echo "DONE"