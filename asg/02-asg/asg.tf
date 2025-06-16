provider "aws" {}

module "example_module" {

    source  = "CheckPointSW/cloudguard-network-security/aws//modules/autoscale"
    version = "1.0.2"

    // --- Environment ---
    prefix = "lab"
    asg_name = "asg"

    // --- VPC Network Configuration ---
    vpc_id = var.vpc_id // "vpc-12345678"
    subnet_ids = var.public_subnets // ["subnet-12345678", "subnet-23456789"]

    // --- Automatic Provisioning with Security Management Server Settings ---
    gateways_provision_address_type = "public"
    management_server = "mgmt_env1"
    configuration_template = "tmpl_env1"

    // --- EC2 Instances Configuration ---
    gateway_name = "asg_gw"
    gateway_instance_type = "c5.xlarge"
    key_name = var.keypair_name
    instances_tags = {
      key1 = "value1"
      key2 = "value2"
    }

    // --- Auto Scaling Configuration ---
    minimum_group_size = 2
    maximum_group_size = 2
    target_groups = [] # ["arn:aws:tg1/abc123", "arn:aws:tg2/def456"]

    // --- Check Point Settings ---
    gateway_version = "R81.20-BYOL"
    admin_shell = "/bin/bash"
    gateway_password_hash = "$5$DKTe6QQSZHMos7EN$taoikN3GtQTPnCqkCV7v.PNqzyFbI4HaAvwlBkLlo64"
    gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
    gateway_SICKey = "12345678"
    enable_instance_connect = false
    allow_upload_download = true
    enable_cloudwatch = false
    gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"

    // --- Outbound Proxy Configuration (optional) ---
    # proxy_elb_type = "internet-facing"
    # proxy_elb_clients = "0.0.0.0/0"
    # proxy_elb_port = 8080
}