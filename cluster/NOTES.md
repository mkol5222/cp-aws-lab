```bash

# cross AZ video https://www.youtube.com/watch?v=izr-tmSQ5es
# CFT https://support.checkpoint.com/results/sk/sk111013

# cross AZ: https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CP_CloudGuard_for_AWS_Cross_AZ_Cluster/Content/Topics-AWS-CrossAZ-Cluster-DG/Getting_Started_with_CloudGuard_Network_for_AWS.htm
# single AZ: https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CloudGuard_Network_for_AWS_Single_AZ_Cluster/Content/Topics-AWS-SingleAZ-Cluster-DG/Introduction.htm

# cross https://github.com/CheckPointSW/terraform-aws-cloudguard-network-security/blob/master/modules/cross_az_cluster/README.md
# single https://github.com/CheckPointSW/terraform-aws-cloudguard-network-security/tree/master/modules/cluster


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
# 13.51.202.207
wait_for_port "13.51.202.207" "18211"