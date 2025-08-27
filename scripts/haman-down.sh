#!/bin/bash

set -euo pipefail

(cd ha-man || exit 1)

(cd ha-man && terraform destroy -auto-approve)

echo
echo "Remaining TF state:"
(cd ha-man; terraform state list)
echo "__END__"