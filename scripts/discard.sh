#!/bin/bash

set -euo pipefail

# SID=$(jq -r .sid ./sid.json)
# expect SID as first argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <SID>"
  exit 1
fi
SID="$1"

# if no SID, exit
if [ -z "$SID" ]; then
  echo "No SID found in sid.json. Please run terraform apply to create a new session."
  exit 1
fi

#if no CHECKPOINT_SERVER and CHECKPOINT_API_KEY, exit
if [ -z "${CHECKPOINT_SERVER:-}" ]; then
  echo "No CHECKPOINT_SERVER found. Please set them it your environment."
  exit 1
fi

CPURL="https://$CHECKPOINT_SERVER/web_api"
# if CHECKPOINT_CLOUD_MGMT_ID defined , URL is different
if [ -n "${CHECKPOINT_CLOUD_MGMT_ID:-}" ]; then
  CPURL="https://$CHECKPOINT_SERVER/$CHECKPOINT_CLOUD_MGMT_ID/web_api"
fi


# login to checkpoint
echo "Discarding session"
DISCARD_RES=$(curl -s -k -X POST "$CPURL/discard" \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $SID" \
  -d "{}")
echo "$DISCARD_RES" | jq -r '.'


echo "Logging out"
curl -s -k -X POST "$CPURL/logout" \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $SID" \
  -d "{}"
echo "Done."

# rm sid.json || true
# echo "Session ID removed."
echo "Session discarded successfully"