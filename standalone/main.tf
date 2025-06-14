provider "aws" {}

module "standalone_cp" {

    source  = "CheckPointSW/cloudguard-network-security/aws//modules/standalone_master"
    version = "1.0.2"

    // --- VPC Network Configuration ---
    vpc_cidr = "10.0.0.0/16"
    public_subnets_map = {
      "eu-north-1a" = 1
    }
    private_subnets_map = {
      "eu-north-1a" = 2
    }
    subnets_bit_length = 8

    // --- EC2 Instance Configuration ---
    standalone_name = "standalone-cp"
    standalone_instance_type = "c5.xlarge"
    key_name = "aws-lab"
    allocate_and_associate_eip = true
    volume_size = 100
    volume_encryption = "alias/aws/ebs"
    enable_instance_connect = false
    disable_instance_termination = false
    instance_tags = {
      "X-mko" = "MadeByTF"
      key2 = "value2"
    }

    // --- Check Point Settings ---
    standalone_version = "R81.20-BYOL"
    admin_shell = "/bin/bash" # "/etc/cli.sh"
    standalone_password_hash = "$5$DKTe6QQSZHMos7EN$taoikN3GtQTPnCqkCV7v.PNqzyFbI4HaAvwlBkLlo64"
    standalone_maintenance_mode_password_hash = ""

    // --- Advanced Settings ---
    resources_tag_name = "tag-name"
    standalone_hostname = "standalone-cp"
    allow_upload_download = true
    enable_cloudwatch = false
    standalone_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
    primary_ntp = ""
    secondary_ntp = ""
    admin_cidr = "0.0.0.0/0"
    gateway_addresses = "0.0.0.0/0"
}