#!/bin/bash

# execute in 
#   make cpman-ssh

mgmt_cli add administrator name "api-user" \
    authentication-method "api key" \
    permissions-profile "Super User" \
    must-change-password false \
    --domain "System Data" \
    -r true --format json

mgmt_cli add-api-key admin-name "api-user" -r true --domain 'System Data' --format json

mgmt_cli -r true install-database targets cpman

curl_cli ip.iol.cz/ip/; echo;