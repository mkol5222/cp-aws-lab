
# CloudGuard Network Security - AWS lab

Repository to demonstrate CloudGuard NS deployment automation into AWS using Terraform.

## Building blocks
- [AWS account](https://aws.amazon.com/) with neccessary permissions to deploy resources.
- [Terraform](https://www.terraform.io/) - Infrastructure as Code tool to deploy resources in AWS and manage CP policy.
- [Check Point Terraform Modules](https://github.com/CheckPointSW/terraform-aws-cloudguard-network-security) for various CloudGuatd NS deployments in AWS

## Instructions

Open project in [Codespace](https://github.com/codespaces/new?repo=mkol5222/cp-aws-lab) or localy in DevContainer and continue.
This environment already has all required tools like `terraform`, AWS CLI installed.

Consider forking this repo [`mkol5222/cp-aws-lab`](https://github.com/mkol5222/cp-aws-lab) before continuing and open Codespace of your forked repository.

Bring AWS credentials into environment variables:
```shell
export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
export AWS_DEFAULT_REGION="eu-north-1" 
```

Deploy Check Point Management Server and wait until it is ready:
```shell
make cpman
```

You can monitor deployment progress with serial line console of new instance:
```shell
make cpman-serial
```

Exit with key sequence `Enter` and then `~.`.

Later SSH will be possible. One can wait for SSH to be available using:
```shell
while true; do make cpman-ssh; sleep 5; done
```