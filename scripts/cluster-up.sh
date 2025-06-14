#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

(cd cluster && terraform init)

(cd cluster && terraform apply -target=module.cluster.aws_route_table.private_subnet_rtb -auto-approve)
(cd cluster && terraform apply -auto-approve)