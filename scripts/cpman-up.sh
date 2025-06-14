#!/bin/bash

set -euo pipefail

(cd management || exit 1)

(cd management && terraform init)

(cd management && terraform apply -auto-approve)