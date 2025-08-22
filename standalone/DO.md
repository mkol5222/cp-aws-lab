# Dynamic Objects lab

```bash
ssh admin@13.49.25.132

# regular DO
dynamic_objects -l

# help
dynamic_objects -h
# DO Overview SK https://support.checkpoint.com/results/sk/sk116367

# our eth0 10.0.1.238

# new object
dynamic_objects -n LocalGatewayExternal
# add IP/range
dynamic_objects -o LocalGatewayExternal -r 10.0.1.238 10.0.1.238 -a
# show all
dynamic_objects -l
# show specific
dynamic_objects -lo LocalGatewayExternal

# lookup IP
dynamic_objects -ip 127.0.0.1
# existing
dynamic_objects -ip 10.0.1.238

# block list
dynamic_objects -n blocklist
# add few ranges
dynamic_objects -o blocklist -r 10.0.1.0 10.0.1.255 -a
dynamic_objects -o blocklist -r 10.0.2.0 10.0.2.255 -a

# look for existing IP
dynamic_objects -ip 10.0.1.238

# better visibility
# see https://github.com/mkol5222/chkp-public-notes/blob/master/cgns/doip.md#why

# download and make executable
curl_cli -k -OL https://github.com/mkol5222/pub.filex/raw/refs/heads/cpfeedman/doip; chmod +x ./doip; 
# test
dynamic_objects -l | ./doip

# grep for IP
dynamic_objects -l | ./doip | grep 10.0.1.238

# compare
dynamic_objects -l | tee /tmp/do1.txt

# some changes
dynamic_objects -o blocklist -r 172.16.0.0 172.16.255.255 -a
# one can also delete sub-ranges
dynamic_objects -o blocklist -r 10.0.1.0 10.0.1.100 -d

# final state
dynamic_objects -l | tee /tmp/do2.txt

# compare
./doip /tmp/do1.txt /tmp/do2.txt
cat /tmp/do1.txt

# delete object
dynamic_objects -do blocklist

# focus on logs
fw log -p -n | grep blocklist

# readable
fw log -p -n | grep 'dynamic object:' | tr \; \\n

# Generic Data Center Objects are DO too (vs CloudGuard Controller objects and DCQ)
# https://support.checkpoint.com/results/sk/sk167210
# https://sc1.checkpoint.com/documents/R81.20/WebAdminGuides/EN/CP_R81.20_SecurityManagement_AdminGuide/Content/Topics-SECMG/Generic-DC-Object.htm
# support file, but always in CP format

# network feeds - they are DO too (EFO - external feed objects)
# https://my.pingdom.com/probes/ipv4
# demo guide https://sc1.checkpoint.com/documents/Sales_tools/DemoPoint/Quantum_R81.20/Topics/Network_Feed_Objects.htm  
# supports processing of flat list or JSON, but does not support local file
dynamic_objects -efo_show

# limitations
# feed https://sc1.checkpoint.com/documents/R82/WebAdminGuides/EN/CP_R82_SecurityManagement_AdminGuide/Content/Topics-SECMG/Network_Feed.htm
# Generic DC 

# expand ranges
dynamic_objects -efo_show | ./doip

# trigget feed update
dynamic_objects -efo_update feed_serv_ip

# look inside
TDERROR_ALL_ALL=1 dynamic_objects -efo_update feed_serv_ip
# e.g. certificates
TDERROR_ALL_ALL=1 dynamic_objects -efo_update feed_serv_ip 2>&1 | grep -i cert
TDERROR_ALL_ALL=1 dynamic_objects -efo_update feed_serv_ip 2>&1 | grep -i bundle

# training Network Feed
curl_cli -k -s https://feed-serv.deno.dev/ip
# formatted
curl_cli -k -s https://feed-serv.deno.dev/ip | jq .
# IPs only
curl_cli -k -s https://feed-serv.deno.dev/ip | jq -r '.[].ip'

# add IP
curl_cli -k -s -X PUT https://feed-serv.deno.dev/ip/127.0.0.1 | jq .
# remove IP
curl_cli -k -s -X DELETE https://feed-serv.deno.dev/ip/127.0.0.1 | jq .

# check if IP is in feed
curl_cli -k -s https://feed-serv.deno.dev/ip | jq -r '.[].ip|select(.=="127.0.0.1")'

# download network feed based on this URL
dynamic_objects -efo_update feed_serv_ip
# see it
dynamic_objects -efo_show | ./doip | grep feed_serv_ip
# look for localhost there
dynamic_objects -efo_show | ./doip | grep feed_serv_ip | grep 127.0.0.1
# delete, fetch and check
curl_cli -k -s -X DELETE https://feed-serv.deno.dev/ip/127.0.0.1 | jq .
dynamic_objects -efo_update feed_serv_ip
dynamic_objects -efo_show | ./doip | grep feed_serv_ip | grep 127.0.0.1
# add, fetch and check
curl_cli -k -s -X PUT https://feed-serv.deno.dev/ip/127.0.0.1 | jq .
dynamic_objects -efo_update feed_serv_ip
dynamic_objects -efo_show | ./doip | grep feed_serv_ip | grep 127.0.0.1

# monitor changes in real time (2 terminals view recommended)
while true; do ./doip <(dynamic_objects -efo_show) <(sleep 2;dynamic_objects -efo_show); done

# 2nd terminal - drive some changes
while true; do curl_cli -k -s -X PUT https://feed-serv.deno.dev/ip/127.0.0.1 | jq .; dynamic_objects -efo_update feed_serv_ip; sleep 5; curl_cli -k -s -X DELETE https://feed-serv.deno.dev/ip/127.0.0.1 | jq .; dynamic_objects -efo_update feed_serv_ip; sleep 3; done


# db location
find $FWDIR/database/ -name '*db'
file $FWDIR/database/dynamic_objects.db
cat $FWDIR/database/dynamic_objects.db

# feed update schedule

# CA checks for feeds
# cpprod_util CPPROD_SetValue FW1 EFO_SKIP_SSL_VALIDATION_$FEEDNAME 1 1 1" to enable 
# cpprod_util CPPROD_SetValue FW1 EFO_SKIP_SSL_VALIDATION_$FEEDNAME 1 0 1" to disable
# CA bundle 
#   https://support.checkpoint.com/results/sk/sk183354

# scheduled updates
cpd_sched_config print

# Feed scale https://support.checkpoint.com/search#q=PRJ-54499

# logs
fw log -p -n | grep efo_
fw log -p -n | grep efo_ | tr \; \\n


# list all OBJECT NAMES
dynamic_objects -l 
dynamic_objects -l | grep -Po "(?<=^object name : )(.*)$"
dynamic_objects -efo_show | grep -Po "(?<=^object name : )(.*)$"

# create 20 dynamic objects
for i in {1..20}; do dynamic_objects -n "DO_demo_$i"; done
dynamic_objects -l | grep -Po "(?<=^object name : )(.*)$"

# DANGER: delete all/some DO?
dynamic_objects -l | grep -Po "(?<=^object name : )(.*)$" | while read DO; do
    # match prefix DO_demo_
    if [[ $DO == DO_demo_* ]]; then
        echo "Deleting $DO"
        dynamic_objects -do "$DO"
    fi
done
dynamic_objects -l | grep -Po "(?<=^object name : )(.*)$"

### DC objects
cat << 'EOF' > /var/log/gdcdemo.json
{
    "version": "1.0",
    "description": "Generic Data Center file example",
    "objects": [
        {
            "name": "Object A name",
            "id": "e7f18b60-f22d-4f42-8dc2-050490ecf6d5",
            "description": "Example for IPv4 addresses",
            "ranges": [
                "91.198.xxx.xxx",
                "20.0.0.0/24",
                "10.1.1.2-10.1.1.10"
            ]
        },
        {
            "name": "Object B name",
            "id": "a46f02e6-af56-48d2-8bfb-f9e8738f2bd0",
            "description": "Example for IPv6 addresses",
            "ranges": [
                "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
                "0064:ff9b:0000:0000:0000:0000:1234:5678/96",
                "2001:0db8:85a3:0000:0000:8a2e:2020:0-2001:0db8:85a3:0000:0000:8a2e:2020:5"
            ]
        }
    ]
}
EOF

mgmt_cli -r true --format json add data-center-server name gendc type generic url /var/log/gdcdemo.json interval 60
dynamic_objects -cfo_show
fw log -n -p | grep gendc | tr \; \\n

less $FWDIR/log/cloud_proxy.elg

# fix JSON
cat << 'EOF' > /var/log/gdcdemo.json
{
    "version": "1.0",
    "description": "Generic Data Center file example",
    "objects": [
        {
            "name": "Object A name",
            "id": "e7f18b60-f22d-4f42-8dc2-050490ecf6d5",
            "description": "Example for IPv4 addresses",
            "ranges": [
                "91.198.10.10",
                "20.0.0.0/24",
                "10.1.1.2-10.1.1.10"
            ]
        },
        {
            "name": "Object B name",
            "id": "a46f02e6-af56-48d2-8bfb-f9e8738f2bd0",
            "description": "Example for IPv6 addresses",
            "ranges": [
                "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
                "0064:ff9b:0000:0000:0000:0000:1234:5678/96",
                "2001:0db8:85a3:0000:0000:8a2e:2020:0-2001:0db8:85a3:0000:0000:8a2e:2020:5"
            ]
        }
    ]
}
EOF

dynamic_objects -cfo_show
# USED IN POLICY only

# not scheduled like EFOs - CloudGuard CONTROLLER has its own scheduling ($FWDIR/log/cloud_proxy.elg)
cpd_sched_config print | less
