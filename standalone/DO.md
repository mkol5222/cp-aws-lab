# Dynamic Objects lab

```bash
# ssh admin@13.49.25.132
make scp-ssh

# help
dynamic_objects -h
# DO Overview SK https://support.checkpoint.com/results/sk/sk116367

# regular DO
dynamic_objects -l


# our eth0 -e.g. 10.0.1.238

# new object
dynamic_objects -n LocalGatewayExternal

# not exist on management server, but can be added
mgmt_cli -r true  add dynamic-object name MailServer

# add IP/range
dynamic_objects -o LocalGatewayExternal -r 10.0.1.238 10.0.1.238 -a
dynamic_objects -l
# or upsert with more than one range
dynamic_objects -u multi -r 10.0.0.0 10.0.0.255 172.16.0.0 172.16.255.255
# show all
dynamic_objects -l
# -u overrides prev state
dynamic_objects -u multi -r 192.168.1.0 192.168.1.255
dynamic_objects -l
# show specific DO only
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
dynamic_objects -l | ./doip | grep LocalGatewayExternal
dynamic_objects -l | ./doip | grep 10.0.1.238

# file 
dynamic_objects -l | tee /tmp/do.txt
cat /tmp/do.txt
./doip /tmp/do.txt | grep 238



# grep for IP
dynamic_objects -l | ./doip | grep 10.0.1.238

# make it smaller
dynamic_objects -l
dynamic_objects -do multi
dynamic_objects -u blocklist -r 10.0.0.1 10.0.0.10
dynamic_objects -l | ./doip
# compare
dynamic_objects -l | tee /tmp/do1.txt

# some changes
dynamic_objects -o blocklist -r 172.16.0.0 172.16.0.2 -a
# one can also delete sub-ranges
dynamic_objects -o blocklist -r 10.0.0.1 10.0.0.5 -d

# final state
dynamic_objects -l | tee /tmp/do2.txt

# compare
diff -u /tmp/do1.txt /tmp/do2.txt
# BUG in doip !!!
./doip /tmp/do1.txt /tmp/do2.txt
 
cat /tmp/do1.txt
cat /tmp/do2.txt

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
# see policy and SmartConsole 

# limitations
# feed https://sc1.checkpoint.com/documents/R82/WebAdminGuides/EN/CP_R82_SecurityManagement_AdminGuide/Content/Topics-SECMG/Network_Feed.htm
# Generic DC 

# expand ranges
dynamic_objects -efo_show | ./doip

# trigget feed update
dynamic_objects -efo_update feed_serv_ip

# look inside GATEWAY SIDE (client)
TDERROR_ALL_ALL=1 dynamic_objects -efo_update feed_serv_ip
# e.g. certificates
TDERROR_ALL_ALL=1 dynamic_objects -efo_update feed_serv_ip 2>&1 | grep -i cert
TDERROR_ALL_ALL=1 dynamic_objects -efo_update feed_serv_ip 2>&1 | grep -i bundle

# training Network Feed - SERVER SIDE
curl_cli -k -s https://feed-serv.deno.dev/ip
# formatted
curl_cli -k -s https://feed-serv.deno.dev/ip | jq .
# IPs only
curl_cli -k -s https://feed-serv.deno.dev/ip | jq -r '.[].ip'
curl_cli -k -s https://feed-serv.deno.dev/ip | jq -r '.[].ip' | grep 127.0.0.1

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
make scp-ssh
while true; do curl_cli -k -s -X PUT https://feed-serv.deno.dev/ip/127.0.0.1 | jq .; dynamic_objects -efo_update feed_serv_ip; sleep 5; curl_cli -k -s -X DELETE https://feed-serv.deno.dev/ip/127.0.0.1 | jq .; dynamic_objects -efo_update feed_serv_ip; sleep 3; done


# db location
find $FWDIR/database/ -name '*db'
file $FWDIR/database/dynamic_objects.db
cat $FWDIR/database/dynamic_objects.db

# feed update schedule

# CA checks for feeds
# export FEEDNAME=quic_cloud
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

### DANGER!!! DELETE ALL DO
dynamic_objects -l | grep -Po "(?<=^object name : )(.*)$" | while read DO; do
        echo "Deleting $DO"
        dynamic_objects -do "$DO"
done
echo
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

cat /var/log/gdcdemo.json | jq .

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

# Gen DC Internals
cat $FWDIR/database/dynamic_objects.db
cat $FWDIR/database/dynamic_objects.db | grep CFO
dynamic_objects -cfo_show
dynamic_objects -cfo_show | grep object

# vs
dynamic_objects -efo_show | grep object
dynamic_objects -l | grep object
```

```bash
# GenDC internals

# 22/08/25 07:39:12,935  INFO ida.api.IDACpridRequestSenderClient [gateway-updater_standalone-cp]: Sending update to gw 10.0.1.238: #!/bin/bash 




# CTF Request data begin:

# Initialize request:
echo "" > /tmp/standalone-cp_ctf_dynobj_commands

# Print Update requests to the commands files:
echo "dynamic_objects -u CP-CFO-40e0783e-a88d-4071-b552-890d1a7514fe -r 10.1.1.2 10.1.1.10 20.0.0.0 20.0.0.255 91.198.10.10 91.198.10.10 " >> /tmp/standalone-cp_ctf_dynobj_commands
echo "dynamic_objects -u CP-CFO-41e79301-629a-44a7-8db4-be8e063a397e -r 64:ff9b:0:0:0:0:0:0 64:ff9b:0:0:0:0:ffff:ffff 2001:db8:85a3:0:0:8a2e:370:7334 2001:db8:85a3:0:0:8a2e:370:7334 2001:db8:85a3:0:0:8a2e:2020:0 2001:db8:85a3:0:0:8a2e:2020:5 " >> /tmp/standalone-cp_ctf_dynobj_commands

# Finalize request:
dynamic_objects -f /tmp/standalone-cp_ctf_dynobj_commands -no_log -cfo >& /tmp/standalone-cp_ctf_dynobj_response
if [ $? -eq 0 ] ; then echo "OK" ; else cat /tmp/standalone-cp_ctf_dynobj_response ; fi

# 22/08/25 07:39:13,256  INFO ida.api.IDACpridRequestSenderClient [gateway-updater_standalone-cp]: Response from gw 10.0.1.238 is 'OK'
```

```bash
# modern DC DCQ - IDA based
pep s u a

# DCQ for tag app=linux1
# our instance
SCP_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=standalone-cp" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

# set tag app to value linux1 on instance SCP_ID
aws ec2 create-tags --resources $SCP_ID --tags Key=app,Value=linux1

# log
fw log -n -p | grep linux1 | grep -i 'ProductName: Identity Awareness' | tr \; \\n
fw log -n -p | grep -i Login | grep -i 'ProductName: Identity Awareness' | tr \; \\n

pep s u a
pdp m a | grep app_linux1
# pep show user query cid <IP address>
# pep show user query cid 10.0.2.85
pdp m a | grep Groups

#  Groups: Name=standalone-cp;app_linux1;vpc-03065f12b0afa1cb7

# remove tag later
aws ec2 delete-tags --resources $SCP_ID --tags Key=app

# log
fw log -n -p | grep -i logout | grep -i 'ProductName: Identity Awareness' | tr \; \\n

# IDA state
pep s u a
pdp m a | grep app_linux1
pdp m a | grep Groups
# Groups: Name=standalone-cp;vpc-03065f12b0afa1cb7

less $FWDIR/log/cloud_proxy.elg

# ATRG https://support.checkpoint.com/results/sk/sk115657

# $FWDIR/conf/vsec_controller_targets_data.set

