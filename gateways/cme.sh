#!/bin/bash

set -euo pipefail

./tfvars.sh

terraform output -json gateways | jq -c '.[]' | while read -r gw; do
  GW=$(echo $gw | jq -r '.name')
  PUBLIC_IP=$(echo $gw | jq -r '.public_ip[0]')
#   ETH0_IP=$(echo $gw | jq -r '.eth0_ip')
#   ETH1_IP=$(echo $gw | jq -r '.eth1_ip')

# use AWS CLI to get the private IPs of the instance
  INSTANCE_ID=$(echo $gw | jq -r '.id')
  ETH0_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
  ETH1_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].NetworkInterfaces[1].PrivateIpAddress' --output text)
  SIC_KEY=$(cat ../secrets/gateway_sic_key.txt)

  echo "To add the gateway $GW with public IP $PUBLIC_IP to the Check Point Management, run the following command on Management console:"

cat <<EOF 

mgmt_cli -r true \
  add simple-gateway \
  name "${GW}" color "blue" \
  ipv4-address "${PUBLIC_IP}" \
  version "R81.20" \
  one-time-password "${SIC_KEY}" \
  firewall true vpn false application-control false url-filtering false ips true \
  anti-bot false anti-virus false threat-emulation false \
  nat-hide-internal-interfaces true \
  icap-server false \
  identity-awareness true \
  identity-awareness-settings.identity-collector true \
  identity-awareness-settings.identity-collector-settings.authorized-clients.client localhost \
  identity-awareness-settings.identity-collector-settings.authorized-clients.client-secret "cnienfrfeinueribf" \
  interfaces.1.name "eth0" interfaces.1.ipv4-address "${ETH0_IP}" interfaces.1.ipv4-network-mask "255.255.255.0" interfaces.1.anti-spoofing false interfaces.1.topology "EXTERNAL" \
  interfaces.2.name "eth1" interfaces.2.ipv4-address "${ETH1_IP}" interfaces.2.ipv4-network-mask "255.255.255.0" interfaces.2.anti-spoofing false interfaces.2.topology "INTERNAL"  \
  --format json

mgmt_cli -r true \
  set simple-gateway \
  name "${GW}" \
  identity-awareness-settings.identity-web-api true \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client "localhost" \
  identity-awareness-settings.identity-web-api-settings.authorized-clients.client-secret "cnienfrfeinueribf" 

EOF

    echo ""
done