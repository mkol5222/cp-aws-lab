#!/bin/bash

set -euo pipefail

(cd ha-man || exit 1)

(cd ha-man && terraform init)

(cd ha-man && terraform apply -auto-approve)