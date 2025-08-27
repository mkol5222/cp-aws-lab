#!/bin/bash

set -euo pipefail

(cd management || exit 1)

(cd management && terraform destroy -auto-approve)

echo
echo "Remaining TF state:"
(cd management; terraform state list)
echo "__END__"