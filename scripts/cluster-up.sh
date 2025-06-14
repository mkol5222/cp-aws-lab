#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

(cd cluster && terraform init)

#(cd cluster && terraform apply -target=module.cluster.aws_route_table.private_subnet_rtb -auto-approve)
(cd cluster && terraform apply -target=module.launch_vpc -auto-approve)
(cd cluster && terraform apply -target=module.cluster -auto-approve)

# data.aws_network_interface.cluster_private_subnet_eni
(cd cluster && terraform apply -target=data.aws_network_interface.cluster_private_subnet_eni -auto-approve)
#(cd cluster && terraform apply -target=aws_subnet.private_subnet_linux -auto-approve)
#(cd cluster && terraform apply -target=aws_route_table_association.private_subnet_linux_rtb_assoc -auto-approve)
(cd cluster && terraform apply -auto-approve)