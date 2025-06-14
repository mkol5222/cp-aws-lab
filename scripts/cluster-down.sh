#!/bin/bash

set -euo pipefail

(cd cluster || exit 1)

(cd cluster && terraform destroy -auto-approve)