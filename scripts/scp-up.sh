#!/bin/bash

set -euo pipefail

(cd standalone || exit 1)

(cd standalone && terraform init)

# terraform apply -target module.standalone_cp.aws_route_table.private_subnet_rtb -auto-approve
(cd standalone && terraform apply -target module.standalone_cp.aws_route_table.private_subnet_rtb -auto-approve)
(cd standalone && terraform apply -auto-approve)