#!/bin/bash

set -euo pipefail

source ./tfvars.sh

terraform destroy -auto-approve

echo "Terrafor state at the end of destroy:"
terraform state list
echo "---"