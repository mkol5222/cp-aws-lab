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
```