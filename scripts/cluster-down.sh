#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

# then cluster to this VPC
(cd cluster && terraform destroy -target=module.cluster -auto-approve)
# SSH keypair and network goest LAST
(cd cluster && terraform destroy -target module.network -auto-approve)

# (cd cluster && terraform destroy -target module.launch_linux -auto-approve)

# data.aws_network_interface.cluster_private_subnet_eni.id

# (cd cluster/; terraform state list | grep eni | while read R; do terraform destroy -target "$R" -auto-approve; done)

# (cd cluster && terraform destroy -target module.cluster -auto-approve)

# all ENI

# (cd cluster && terraform apply -target data.aws_network_interface.cluster_private_subnet_eni -auto-approve)
# (cd cluster && terraform destroy -auto-approve)

echo "Remaining TF state:"
(cd cluster; terraform state list)
echo "__END__"