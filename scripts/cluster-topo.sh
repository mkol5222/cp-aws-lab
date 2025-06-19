#!/bin/bash

set -euo pipefail

# aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*]" --output json \
#     | jq -c -r '.[] | .[] | {ID: .InstanceId, State: .State.Name, Type: .InstanceType, PublicIP: .PublicIpAddress, PrivateIP: .PrivateIpAddress, NetworkInterfaces: .NetworkInterfaces}'

GWLINES=$(aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*]" --output json \
    | jq -c -r '.[] | .[] | {Tags: .Tags,ID: .InstanceId, State: .State.Name, Type: .InstanceType, PublicIP: .PublicIpAddress, PrivateIP: .PrivateIpAddress, NetworkInterfaces: .NetworkInterfaces}')

echo "$GWLINES" | while read MEMBER; do
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

# node A
# echo "$GWLINES" | head -1
HA1_ETH0_PUB=$(echo "$GWLINES" | grep cluster-Member-A | jq -r '.PublicIP')
HA1_ETH0=$(echo "$GWLINES" | grep cluster-Member-A | jq -r '.PrivateIP')
# HA1_ETH1=$(echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[0].PrivateIpAddresses[0].PrivateIpAddress')
# member IP internal
HA1_ETH1=$(echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[] | select(.Description=="Member A internal")| .PrivateIpAddresses[] | select(.Primary)|.PrivateIpAddress')

# VIP_ETH0=$(echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[1].PrivateIpAddresses[1].PrivateIpAddress')
# cluster IP external
VIP_ETH0=$(echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[] | select(.Description=="Member A external")| .PrivateIpAddresses[]| select(.Primary == false)|.PrivateIpAddress')

# VIP_ETH1=$(echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[0].PrivateIpAddresses[1].PrivateIpAddress')
# cluster IP internal
VIP_ETH1=$(echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[] | select(.Description=="Member A internal")| .PrivateIpAddresses[]| select(.Primary == false)|.PrivateIpAddress')

echo "node A Public IP: $HA1_ETH0_PUB"
echo "node A Private IP: $HA1_ETH0 (eth0) and $HA1_ETH1 (eth1)"


# member IP 
# echo "$GWLINES" | grep cluster-Member-A | jq -c -r '.NetworkInterfaces[] | select(.Description=="Member A external")| .PrivateIpAddresses[] | select(.Primary)|.PrivateIpAddress'



#echo "$GWLINES" | head -1 | jq -c -r '.NetworkInterfaces[].PrivateIpAddresses[].Association'

# echo "$GWLINES" | head -1 | jq -c -r '.NetworkInterfaces[1].PrivateIpAddresses[1].PrivateIpAddress'

#HA2_ETH1=$(echo "$GWLINES" | grep cluster-Member-B | jq -c -r '.NetworkInterfaces[1].PrivateIpAddresses[0].PrivateIpAddress')
# echo "$GWLINES" | grep cluster-Member-B | jq -c -r '.NetworkInterfaces[1].PrivateIpAddresses[1].PrivateIpAddress'

# exit 

# node B
echo
# echo "$GWLINES" | grep cluster-Member-B
HA2_ETH0_PUB=$(echo "$GWLINES" | grep cluster-Member-B | jq -r '.PublicIP')
HA2_ETH0=$(echo "$GWLINES" | grep cluster-Member-B | jq -r '.PrivateIP')
# HA2_ETH1=$(echo "$GWLINES" | grep cluster-Member-B | jq -c -r '.NetworkInterfaces[0].PrivateIpAddresses[0].PrivateIpAddress')

# member IP internal
HA2_ETH1=$(echo "$GWLINES" | grep cluster-Member-B | jq -c -r '.NetworkInterfaces[] | select(.Description=="Member B internal")| .PrivateIpAddresses[] | select(.Primary)|.PrivateIpAddress')


echo "node B Public IP: $HA2_ETH0_PUB"
echo "node B Private IP: $HA2_ETH0 (eth0) and $HA2_ETH1 (eth1)"

VIP_PUB=$(cd cluster; terraform output -raw ip_clu)



echo
echo "Cluster VIP Public IP: $VIP_PUB"
echo "Cluster IP ${VIP_ETH0} (eth0) and $VIP_ETH1 (eth1)"
echo

#     send-logs-to-server cpman-pub \

cat <<EOF
mgmt_cli -r true add simple-cluster name "clu"\
    color "pink"\
    version "R81.20"\
    ip-address "${VIP_ETH0}"\
    os-name "Gaia"\
    cluster-mode "cluster-xl-ha"\
    firewall true\
    vpn false\
    interfaces.1.name "eth0"\
    interfaces.1.ip-address "${VIP_ETH0}"\
    interfaces.1.network-mask "255.255.255.0"\
    interfaces.1.interface-type "cluster"\
    interfaces.1.topology "EXTERNAL"\
    interfaces.1.anti-spoofing false \
    interfaces.2.name "eth1"\
    interfaces.2.ip-address "${VIP_ETH1}"\
    interfaces.2.network-mask "255.255.255.0"\
    interfaces.2.interface-type "sync"\
    interfaces.2.topology "INTERNAL"\
    interfaces.2.topology-settings.ip-address-behind-this-interface "network defined by the interface ip and net mask"\
    interfaces.2.topology-settings.interface-leads-to-dmz false\
    interfaces.2.anti-spoofing false \
    members.1.name "clu1"\
    members.1.one-time-password "12345678"\
    members.1.ip-address "${HA1_ETH0_PUB}"\
    members.1.interfaces.1.name "eth0"\
    members.1.interfaces.1.ip-address "${HA1_ETH0}"\
    members.1.interfaces.1.network-mask "255.255.255.0"\
    members.1.interfaces.2.name "eth1"\
    members.1.interfaces.2.ip-address "${HA1_ETH1}"\
    members.1.interfaces.2.network-mask "255.255.255.0"\
    members.2.name "clu2"\
    members.2.one-time-password "12345678"\
    members.2.ip-address "${HA2_ETH0_PUB}"\
    members.2.interfaces.1.name "eth0"\
    members.2.interfaces.1.ip-address "${HA2_ETH0}"\
    members.2.interfaces.1.network-mask "255.255.255.0"\
    members.2.interfaces.2.name "eth1"\
    members.2.interfaces.2.ip-address "${HA2_ETH1}"\
    members.2.interfaces.2.network-mask "255.255.255.0"\
    nat-hide-internal-interfaces true \
    --format json
EOF

echo
echo "Install policy with:"
echo "   mgmt_cli install-policy policy-package "cluster" access true threat-prevention true targets.1 "clu"  --format json -r true"
echo

