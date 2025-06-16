#!/bin/bash

set -euo pipefail

(cd asg || exit 1)

# Linux first
echo "LINUX down"
(cd asg && terraform destroy -target module.linux -auto-approve)
# then asg to this VPC
echo "ASG down"
(cd asg && terraform destroy -target module.asg -auto-approve)
#  network
echo "NETWORK down"
(cd asg && terraform destroy -target module.network -auto-approve)
# SSH keypair 
echo "SSH down"
(cd asg && terraform destroy -target module.ssh -auto-approve)

# (cd asg/; terraform state list | grep eni | while read R; do terraform destroy -target "$R" -auto-approve; done)

# (cd asg && terraform destroy -auto-approve)

echo
echo "Remaining TF state:"
(cd asg; terraform state list)
echo "__END__"