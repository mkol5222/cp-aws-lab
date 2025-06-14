provider "aws" {}

module "cluster" {

    source  = "CheckPointSW/cloudguard-network-security/aws//modules/cluster_master"
    version = "1.0.2"


    // --- VPC Network Configuration ---
    vpc_cidr = "10.109.0.0/16"
    public_subnets_map = {
      "eu-north-1a" = 1
    }
    private_subnets_map = {
      "eu-north-1a" = 2
    }
    subnets_bit_length = 8

    // --- EC2 Instance Configuration ---
    gateway_name = "cluster"
    gateway_instance_type = "c5.xlarge"
    key_name = aws_key_pair.generated_key.key_name
    allocate_and_associate_eip = true
    volume_size = 100
    volume_encryption = "alias/aws/ebs"
    enable_instance_connect = false
    disable_instance_termination = false
    instance_tags = {
    "X-mko" = "MadeByTF"
    "X-mko-role" = "cluster"
    }
    predefined_role = ""

    // --- Check Point Settings ---
    gateway_version = "R81.20-BYOL"
    admin_shell = "/bin/bash"
    gateway_SICKey = "12345678"
    gateway_password_hash = "$5$DKTe6QQSZHMos7EN$taoikN3GtQTPnCqkCV7v.PNqzyFbI4HaAvwlBkLlo64"
    gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.

    // --- Quick connect to Smart-1 Cloud (Recommended) ---
    memberAToken = ""
    memberBToken = ""
  
    // --- Advanced Settings ---
    resources_tag_name = "tag-name"
    gateway_hostname = "clu"
    allow_upload_download = true
    enable_cloudwatch = false
    gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
    primary_ntp = ""
    secondary_ntp = ""
  }