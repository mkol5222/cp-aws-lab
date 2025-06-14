#!/bin/bash

set -euo pipefail

# aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*]" --output json \
#     | jq -c -r '.[] | .[] | {ID: .InstanceId, State: .State.Name, Type: .InstanceType, PublicIP: .PublicIpAddress, PrivateIP: .PrivateIpAddress, NetworkInterfaces: .NetworkInterfaces}'

aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*]" --output json \
    | jq -c -r '.[] | .[] | {Tags: .Tags,ID: .InstanceId, State: .State.Name, Type: .InstanceType, PublicIP: .PublicIpAddress, PrivateIP: .PrivateIpAddress, NetworkInterfaces: .NetworkInterfaces}' \
    | while read MEMBER; do
        ID=$(echo "$MEMBER" | jq -r '.ID')
        STATE=$(echo "$MEMBER" | jq -r '.State')
        TYPE=$(echo "$MEMBER" | jq -r '.Type')
        PUBLIC_IP=$(echo "$MEMBER" | jq -r '.PublicIP // "N/A"')
        PRIVATE_IP=$(echo "$MEMBER" | jq -r '.PrivateIP // "N/A"')
        NETWORK_INTERFACES=$(echo "$MEMBER" | jq -c -r '.NetworkInterfaces[]')
        TAG_NAME=$(echo "$MEMBER" | jq -r '.Tags[] | select(.Key == "Name") | .Value // "N/A"')

        echo "Instance ID: $ID: $TAG_NAME"
        echo "  State: $STATE"
        echo "  Type: $TYPE"
        echo "  Public IP: $PUBLIC_IP"
        echo "  Private IP: $PRIVATE_IP"
        
        #// NetworkInterfaces[] / PrivateIpAddresses[] / Association / PublicIp

        echo -n "  Public IPs from Network Interfaces: "
        echo "$MEMBER" | jq -c -r '[.NetworkInterfaces[].PrivateIpAddresses[].Association.PublicIp | select(. != null)]|join(",")' 
        echo


        if [ -n "$NETWORK_INTERFACES" ]; then
            echo "  Network Interfaces:"
            echo "$NETWORK_INTERFACES" | jq -c -r '. | {ID: .NetworkInterfaceId, SubnetId: .SubnetId, VpcId: .VpcId, PrivateIpAddress: .PrivateIpAddress}'
        fi
        echo
    done
echo "Cluster topology information retrieved successfully."
