
module "cpman" {

    source  = "CheckPointSW/cloudguard-network-security/aws//modules/management"
    version = "1.0.2"

    // --- VPC Network Configuration ---
    vpc_id = module.launch_vpc.vpc_id
    subnet_id = module.launch_vpc.public_subnets_ids_list[0]
    
    // --- EC2 Instances Configuration ---
    management_name = "cpman"
    management_instance_type = "m5.xlarge"
    key_name = aws_key_pair.generated_key.key_name // "cpman-keypair"
    allocate_and_associate_eip = true
    volume_size = 100
    volume_encryption = "alias/aws/ebs"
    enable_instance_connect = false
    disable_instance_termination = false
    instance_tags = {
      key1 = "value1"
      key2 = "value2"
      "X-mko" = "MadeByTF"
      "X-mko-role" = "cpman"
    }
    
    // --- IAM Permissions ---
    iam_permissions = "Create with read permissions"
    predefined_role = ""
    sts_roles = []
    
    // --- Check Point Settings ---
    management_version = "R81.20-BYOL"
    admin_shell = "/bin/bash"
    management_password_hash = "$5$DKTe6QQSZHMos7EN$taoikN3GtQTPnCqkCV7v.PNqzyFbI4HaAvwlBkLlo64"
    management_maintenance_mode_password_hash = "" # For R81.10 and below the management_password_hash is used also as maintenance-mode password.
    // --- Security Management Server Settings ---
    management_hostname = "cpman"
    management_installation_type = "Primary management"
    SICKey = ""
    allow_upload_download = "true"
    gateway_management = "Over the internet" //"Locally managed"
    admin_cidr = "0.0.0.0/0"
    gateway_addresses = "0.0.0.0/0"
    primary_ntp = ""
    secondary_ntp = ""
    management_bootstrap_script = "mgmt_cli -r true set api-settings accepted-api-calls-from 'All IP addresses' --domain 'System Data' --format json; (date; uptime; ) > /home/admin/bootstrap.txt"
}