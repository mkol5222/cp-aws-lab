#!/bin/bash

set -euo pipefail

(cd standalone || exit 1)

(cd standalone && terraform destroy -auto-approve)

echo
echo "Remaining TF state:"
(cd standalone; terraform state list)
echo "__END__"