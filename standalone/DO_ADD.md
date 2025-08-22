```bash

# all gws and cluster members
( (mgmt_cli -r true show simple-gateways details-level full limit 100 --format json | jq -r -c '.objects[] | {gw:.name, ip: ."ipv4-address"}'); (mgmt_cli -r true show simple-clusters details-level full limit 100 --format json | jq -r -c '.objects[]."cluster-members"[]| {gw:.name, ip: ."ip-address"}' )) | while read gw; do
    GW_NAME=$(echo "$gw" | jq -r '.gw')
    GW_IP=$(echo "$gw" | jq -r '.ip')
    echo "Gateway: ${GW_NAME}, IP: ${GW_IP}"
done

GW_IPS=$(
( (mgmt_cli -r true show simple-gateways details-level full limit 100 --format json | jq -r -c '.objects[] | {gw:.name, ip: ."ipv4-address"}'); (mgmt_cli -r true show simple-clusters details-level full limit 100 --format json | jq -r -c '.objects[]."cluster-members"[]| {gw:.name, ip: ."ip-address"}' )) | while read gw; do
    GW_NAME=$(echo "$gw" | jq -r '.gw')
    GW_IP=$(echo "$gw" | jq -r '.ip')
    echo "$GW_IP"
done
)

echo $GW_IPS

# establish some DOs on each GW - consider running few times
for GW_IP in $GW_IPS; do
    # 6 digit random hex string using openssl
    DO_ID=$(openssl rand -hex 3)
    DO_NAME="random_do_$DO_ID"
    echo "Establishing DO $DO_NAME on Gateway IP: $GW_IP"
    cprid_util -server "$GW_IP" -verbose rexec -rcmd dynamic_objects -n "$DO_NAME"
done

# print all established DOs
DOS=$(for GW_IP in $GW_IPS; do
    cprid_util -server "$GW_IP" -verbose rexec -rcmd dynamic_objects -l | grep -Po "(?<=^object name : )(random_do_.*)"
done)

echo "Established DOs:"
echo "$DOS" | sort | uniq

# make objects for them
for DO_NAME in $DOS; do
    echo "Creating object $DO_NAME"
    # Add your object creation commands here
    mgmt_cli -r true add dynamic-object name "$DO_NAME" tags automagic_demo --format json
done

# check them - print list filtered by tag
mgmt_cli -r true show dynamic-objects filter automagic_demo --format json | jq -c '.objects[] | {name: .name, uid: .uid}'

```