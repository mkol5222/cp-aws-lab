```powershell

# powershell
$env:AWS_ACCESS_KEY_ID="{your-access-key-id}"
$env:AWS_SECRET_ACCESS_KEY="{your-secret-access-key}"
$env:AWS_DEFAULT_REGION="eu-north-1"
# aws cli
winget install -e Amazon.AWSCLI

aws configure
aws sts get-caller-identity
``
 