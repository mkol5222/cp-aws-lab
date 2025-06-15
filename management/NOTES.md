```bash

# list instances by name cpman
aws ec2 describe-instances --filters "Name=tag:Name,Values=cpman" --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,PrivateIpAddress,Tags[?Key=='Name'].Value | [0]]" --output table

# set SSH key for serial console access
ls -la ~/.ssh/id_rsa.pub
ssh-keygen # if needed

INSTANCE_ID=$(terraform output -raw id)
echo "Instance ID: $INSTANCE_ID"
aws ec2-instance-connect send-serial-console-ssh-public-key \
    --instance-id "$INSTANCE_ID" \
    --serial-port 0 \
    --ssh-public-key file://~/.ssh/id_rsa.pub \
    --region eu-north-1

# connect to serial console
aws ec2 enable-serial-console-access
aws ec2 get-serial-console-access-status

# ssh -i ~/.ssh/id_rsa i-00ebe271d7892fa64.port0@serial-console.ec2-instance-connect.eu-north-1.aws
echo  ssh -i ~/.ssh/id_rsa "${INSTANCE_ID}.port0@serial-console.ec2-instance-connect.eu-north-1.aws"
ssh -i ~/.ssh/id_rsa "${INSTANCE_ID}.port0@serial-console.ec2-instance-connect.eu-north-1.aws"

# leave with Enter ~. Enter ~. to exit the serial console


# make API accessible from all IP addresses
mgmt_cli -r true set api-settings accepted-api-calls-from "All IP addresses"  --domain 'System Data' --format json


INSTANCE_ID=$(cd management; terraform output -raw id)

# if not provided, exit
if [ -z "$INSTANCE_ID" ]; then
  echo "Instance ID not provided. Exiting."
  exit 1
fi

# ip address
IP_ADDRESS=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
if [ -z "$IP_ADDRESS" ]; then
  echo "No public IP address found for instance $INSTANCE_ID. Exiting."
  exit 1
fi

echo $IP_ADDRESS
echo mgmt_cli -r true add checkpoint-host name "cpman-pub" ipv4-address "$IP_ADDRESS" management-blades.network-policy-management false management-blades.logging-and-status true  --format json

# add network net-linux with 172.17.3.0/24
mgmt_cli -r true add network name "net-linux" subnet "172.17.3.0" subnet-mask "255.255.255.0"  --format json
```