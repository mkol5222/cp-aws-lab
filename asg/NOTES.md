

```shell

# template

autoprov_cfg init AWS -mn mgmt_env1 -tn tmpl_env1 -otp 12345678 -po Standard -cn cpman -r eu-north-1 -iam -ver R81.20
autoprov_cfg set template -tn tmpl_env1 -ia -ips
tail -f  /var/log/CPcme/cme.log 
    # management_server = "mgmt_env1"
    # configuration_template = "tmpl_env1"
    #     gateway_SICKey = "12345678"


# query ASG instances - id and IPs using AWS cli
aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=lab-asg_gw*" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]" \
    --output text

