#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

(cd cluster && terraform destroy -target module.launch_linux -auto-approve)
(cd cluster && terraform destroy -target module.cluster -auto-approve)

# all ENI

(cd cluster && terraform destroy -auto-approve)