#!/bin/bash

set -euo pipefail

# expect SID as first argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <SID>"
  exit 1
fi
SID="$1"

# expect CHECKPOINT_ variables to be set
if [ -z "${CHECKPOINT_SERVER:-}" ]; then
  echo "CHECKPOINT_SERVER is not set"
  exit 1
fi

CPURL="https://$CHECKPOINT_SERVER/web_api"
# if CHECKPOINT_CLOUD_MGMT_ID defined , URL is different
if [ -n "${CHECKPOINT_CLOUD_MGMT_ID:-}" ]; then
  CPURL="https://$CHECKPOINT_SERVER/$CHECKPOINT_CLOUD_MGMT_ID/web_api"
fi


# login to checkpoint
echo "Publishing session"
PUBLISH_RES=$(curl -s -k -X POST "$CPURL/publish" \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $SID" \
  -d "{}")

TASK_ID=$(echo "$PUBLISH_RES" | jq -r '."task-id"')
if [ "$TASK_ID" == "null" ]; then
  echo "Error publishing session: $PUBLISH_RES"
  exit 1
fi

# monitor task until it is done
while true; do
  TASK_STATUS=$(curl -s -k -X POST "$CPURL/show-task" \
    -H "Content-Type: application/json" \
    -H "X-chkp-sid: $SID" \
    -d "{\"task-id\": \"$TASK_ID\", \"details-level\": \"full\"}")

echo "Task status: $TASK_STATUS"
  STATUS=$(echo "$TASK_STATUS" | jq -r '.tasks[0].status')
    echo "Status: $STATUS"
  if [ "$STATUS" == "succeeded" ]; then
    echo "Session published successfully"
    break
  elif [ "$STATUS" == "failed" ]; then
    echo "Error publishing session: $TASK_STATUS"
    exit 1
  fi

  sleep 2
done

echo "Logging out"
curl -s -k -X POST "$CPURL/logout" \
  -H "Content-Type: application/json" \
  -H "X-chkp-sid: $SID" \
  -d "{}"
echo "Done."

# rm sid.json || true
# echo "Session ID removed."
echo "Session published successfully"