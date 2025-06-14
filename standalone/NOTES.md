```shell


wsl openssl passwd -5

terraform init

terraform apply -target module.standalone_cp.aws_route_table.private_subnet_rtb -auto-approve

terraform apply


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
```