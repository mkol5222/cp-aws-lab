```bash

# list EC2 instances by tag X-mko-role = cluster
aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Type:InstanceType,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}" --output table

# full instance details, especially network interfaces and IP addresses
aws ec2 describe-instances --filters "Name=tag:X-mko-role,Values=cluster" --query "Reservations[*].Instances[*]" --output json \
    | jq -r '.[] | .[] | {ID: .InstanceId, State: .State.Name, Type: .InstanceType, PublicIP: .PublicIpAddress, PrivateIP: .PrivateIpAddress, NetworkInterfaces: .NetworkInterfaces}'


mgmt_cli -r true set simple-cluster name "clu"\
    nat-hide-internal-interfaces true