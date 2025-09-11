#!/bin/bash

set -euo pipefail

source ./tfvars.sh

terraform init

terraform apply '-target=module.gw["gw1"].aws_route_table.private_subnet_rtb' -auto-approve \
  && terraform apply -auto-approve

