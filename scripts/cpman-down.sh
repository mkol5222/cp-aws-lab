#!/bin/bash

set -euo pipefail

(cd management || exit 1)

(cd management && terraform destroy -auto-approve)