#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

# (cd cluster && terraform destroy -target module.launch_linux -auto-approve)

# data.aws_network_interface.cluster_private_subnet_eni.id

# (cd cluster && terraform destroy -target module.cluster -auto-approve)

# all ENI

# (cd cluster && terraform apply -target data.aws_network_interface.cluster_private_subnet_eni -auto-approve)
(cd cluster && terraform destroy -auto-approve)

echo
(cd cluster; terraform state list)