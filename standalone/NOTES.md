```shell


wsl openssl passwd -5

terraform init

terraform apply -target module.standalone_cp.aws_route_table.private_subnet_rtb -auto-approve

terraform apply -auto-approve


terraform output

# query instance via aws cli
aws ec2 describe-instances  --query "Reservations[].Instances[].{ID:InstanceId,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}" --output table
# with all tags
aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,PrivateIpAddress,Tags[?Key=='Name'].Value | [0]]" --output table
# query instance via aws cli with filter
aws ec2 describe-instances --filters "Name=tag:Name,Values=standalone-cp" --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,PrivateIpAddress,Tags[?Key=='Name'].Value | [0]]" --output table
# query and skip terminated instaces
aws ec2 describe-instances --filters "Name=tag:Name,Values=standalone-cp" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,PrivateIpAddress,Tags[?Key=='Name'].Value | [0]]" --output table

# list my SSH keys
aws ec2 describe-key-pairs --query "KeyPairs[].{Name:KeyName, Fingerprint:KeyFingerprint}" --output table


# create new SSH keypair in EC2
aws ec2 create-key-pair --key-name aws-lab --query "KeyMaterial" --output text > aws-lab.pem

# connect serial console of EC2 instance using AWS CLI, no sending of keys
aws ec2 enable-serial-console-access
aws ec2 get-serial-console-access-status

ssh-keygen # if needed

aws ec2-instance-connect send-serial-console-ssh-public-key \
    --instance-id i-00ebe271d7892fa64 \
    --serial-port 0 \
    --ssh-public-key file://~/.ssh/id_rsa.pub \
    --region eu-north-1


ssh -i ~/.ssh/id_rsa i-00ebe271d7892fa64.port0@serial-console.ec2-instance-connect.eu-north-1.aws


#  vs ssh
aws ec2-instance-connect ssh \
  --instance-id i-00ebe271d7892fa64 \
  --region eu-north-1

```