#!/bin/bash

set -euo pipefail

echo "Stopping cluster members..."

function memberInstanceId 
{
  MEMBER="${1:-a}"
  MEMBER_UPERCASE=$(echo "$MEMBER" | tr '[:lower:]' '[:upper:]')

  # look for running instance Named cluster-Member-A or cluster-Member-B
  INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=cluster-Member-${MEMBER_UPERCASE}" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)
  # if not found, exit
  if [ -z "$INSTANCE_ID" ]; then
    echo "Instance ID for cluster-Member-${MEMBER_UPERCASE} not found. Exiting." >&2
    echo ""
  else
    echo "Instance ID for cluster-Member-${MEMBER_UPERCASE}: $INSTANCE_ID" >&2
    echo "$INSTANCE_ID"
  fi
}

function stopInstanceId {
  INSTANCE_ID=$1
  aws ec2 stop-instances --instance-ids $INSTANCE_ID

  INSTANCE_STATE=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query "Reservations[].Instances[].State.Name" \
    --output text)
  echo $INSTANCE_STATE
}

function InstanceIdState {
  local IID=$1
  aws ec2 describe-instances \
    --instance-ids $IID \
    --query "Reservations[].Instances[].State.Name" \
    --output text
}

# memberInstanceId "A"
# memberInstanceId "B"

for NODE in A B; do
   echo Stopping member $NODE
   INSTANCEID=$(memberInstanceId "$NODE")
   echo "Instance ID $NODE: $INSTANCEID"
   # empty instance ID
   if [ -z "$INSTANCEID" ]; then
     echo "No running instance found for cluster-Member-$NODE"
  else
     if [ "$(InstanceIdState $INSTANCEID)" == "running" ]; then
       stopInstanceId $INSTANCEID
     else
       echo "Instance ID $NODE: $INSTANCEID is not running"
     fi
   fi
done

