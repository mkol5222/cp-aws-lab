```shell


# look for EC2 instance named standalone-cp
SCP_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=standalone-cp" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

# set tag app to value linux1 on instance SCP_ID
aws ec2 create-tags --resources $SCP_ID --tags Key=app,Value=linux1

# start it
aws ec2 start-instances --instance-ids $SCP_ID


SCP_STATE=$(aws ec2 describe-instances \
  --instance-ids $SCP_ID \
  --query "Reservations[].Instances[].State.Name" \
  --output text)
echo $SCP_STATE

SCP_IP=$(aws ec2 describe-instances \
--instance-ids $SCP_ID \
--query "Reservations[].Instances[].PublicIpAddress" \
--output text)

timeout 3 ssh -q admin@$SCP_IP hostname -i

aws ec2 stop-instances --instance-ids $SCP_ID

# This will put the instance into the stopping → stopped state. You can check progress with:

while true; do ssh -q admin@$SCP_IP; sleep 2; done
watch -d 'api status | grep read'
ssh -q admin@$SCP_IP api status | grep read


######################
 terraform state show module.cme_role.aws_iam_instance_profile.iam_instance_profile
# module.cme_role.aws_iam_instance_profile.iam_instance_profile:
resource "aws_iam_instance_profile" "iam_instance_profile" {
    arn         = "arn:aws:iam::141317330670:instance-profile/terraform-20250821132754281800000004"
    create_date = "2025-08-21T13:27:54Z"
    id          = "terraform-20250821132754281800000004"
    name        = "terraform-20250821132754281800000004"
    name_prefix = "terraform-"
    path        = "/"
    role        = "terraform-20250821132753284200000002"
    tags        = {}
    tags_all    = {}
    unique_id   = "AIPASBZZLK3XIZBYL5OLW"
}


 aws iam list-instance-profiles --query "InstanceProfiles[].InstanceProfileName" --output text
terraform-20250821132754281800000004

aws ec2 associate-iam-instance-profile \
  --instance-id i-08f621ad4b613ecae \
  --iam-instance-profile Name=terraform-20250821132754281800000004


  aws ec2 describe-instances \
    --instance-id i-08f621ad4b613ecae \
    --query "Reservations[].Instances[].IamInstanceProfile"

wsl openssl passwd -5

terraform init

terraform apply -target module.standalone_cp.aws_route_table.private_subnet_rtb -auto-approve

terraform apply -auto-approve


terraform output

terraform destroy -auto-approve

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

# Check password hash
HASH='$5$DKTe6QQSZHMos7EN$taoikN3GtQTPnCqkCV7v.PNqzyFbI4HaAvwlBkLlo64'
PASS='candidate_password'

if [ "$(openssl passwd -5 -salt "$(echo "$HASH" | cut -d'$' -f3,4)" "$PASS")" = "$HASH" ]; then
  echo "✅ Password matches"
else
  echo "❌ Password does NOT match"
fi


# add authorized ssh key
# cat ~/.ssh/id_rsa.pub | ssh -i ~/.ssh/id_rsa admin@$SCP_IP 'cat >> ~/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub | clip.exe

# from clipboard, on SERIAL
make scp-serial
# cat | tee -a ~/.ssh/authorized_keys
exit
make scp-ssh

# enable API access
mgmt_cli -r true set api-settings accepted-api-calls-from "All IP addresses" --domain 'System Data'
echo "Restarting API Server"
api restart


