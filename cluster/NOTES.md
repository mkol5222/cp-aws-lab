```bash

# list EC2 instances by tag X-mko-role = cluster
aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Type:InstanceType,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}" --output table

# full instance details, especially network interfaces and IP addresses
aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*]" --output json \
    | jq -r '.[] | .[] | {ID: .InstanceId, State: .State.Name, Type: .InstanceType, PublicIP: .PublicIpAddress, PrivateIP: .PrivateIpAddress, NetworkInterfaces: .NetworkInterfaces}'


mgmt_cli -r true set simple-cluster name "clu"\
    nat-hide-internal-interfaces true


timeout 5 bash -c "</dev/tcp/13.50.184.210/18211" && echo "Port open" || echo "Port closed"
timeout 5 bash -c "</dev/tcp/56.228.40.217/18211" && echo "Port open" || echo "Port closed"

# IOL.cz 194.228.41.73
timeout 5 bash -c "</dev/tcp/194.228.41.73/80" && echo "Port open" || echo "Port closed"

function check_port() {
    local ip=$1
    local port=$2
    timeout 5 bash -c "</dev/tcp/$ip/$port" && echo "closed" || echo "open"
}
check_port "13.50.184.210" "18211"

# wait for port to be open
function wait_for_port() {
    local ip=$1
    local port=$2
    while ! timeout 5 bash -c "</dev/tcp/$ip/$port"; do
        echo "Waiting for $ip:$port to be open..."
        sleep 5
    done
    echo "$ip:$port is now open."
}
wait_for_port "13.50.184.210" "18211"