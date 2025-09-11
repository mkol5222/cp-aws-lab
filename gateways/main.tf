

locals {
  region = "eu-north-1"
  gateways = [
    {
      gateway_name       = "gw1"
      #instance_type      = "c5.xlarge" # go medium 4 vCPU, 8 GB RAM
      instance_type      = "c6in.large" # go small 2 vCPU, 4 GB RAM, Intel
      key_name           = aws_key_pair.generated_key.key_name
      vpc_cidr           = "10.151.0.0/16"
      subnets_bit_length = 8 # /24 subnets
      public_subnets_map = {
        "${local.region}a" = 1 // 10.151.1.0/24
      }
      private_subnets_map = {
        "${local.region}a" = 2 // 10.151.2.0/24
      }

      gateway_version       = "R81.20-BYOL"
      admin_shell           = "/bin/bash"

      gateway_SICKey                                 = var.gateway_sic_key
      gateway_password_hash                          = var.gateway_admin_password

      control_gateway_over_public_or_private_address = "public"
    }
  ]
}

provider "aws" {}


# outputs 
# vpc_id	The id of the deployed vpc
# internal_rt_id	The internal route table id
# vpc_public_subnets_ids_list	A list of the public subnets ids
# vpc_private_subnets_ids_list	A list of the private subnets ids
# ami_id	The ami id of the deployed Security Gateway
# permissive_sg_id	The permissive security group id
# permissive_sg_name	The permissive security group id name
# gateway_url	URL to the portal of the deployed Security Gateway
# gateway_public_ip	The deployed Security Gateway Server AWS public ip
# gateway_instance_id	The deployed Security Gateway AWS instance id
# gateway_instance_name	The deployed Security Gateway AWS instance name
# ---

output "gateways" {
    description = "List of deployed gateways"
    value       = [for gw in module.gw : {
        name               = gw.gateway_instance_name
        id                 = gw.gateway_instance_id
        public_ip         = gw.gateway_public_ip
        # private_ip        = gw.gateway_private_ip
        url                = gw.gateway_url
        vpc_id             = gw.vpc_id
        public_subnet_ids  = gw.vpc_public_subnets_ids_list
        private_subnet_ids = gw.vpc_private_subnets_ids_list
        ami_id             = gw.ami_id
        sg_id              = gw.permissive_sg_id
        sg_name            = gw.permissive_sg_name
    }]
    sensitive   = true
}

module "gw" {

  depends_on = [aws_key_pair.generated_key]

  for_each = { for gw in local.gateways : gw.gateway_name => gw }

  source  = "CheckPointSW/cloudguard-network-security/aws//modules/gateway_master"
  version = "1.0.2"

  // --- VPC Network Configuration ---
  vpc_cidr            = each.value.vpc_cidr
  public_subnets_map  = each.value.public_subnets_map
  private_subnets_map = each.value.private_subnets_map
  subnets_bit_length  = each.value.subnets_bit_length

  // --- EC2 Instance Configuration ---
  gateway_name                 = each.value.gateway_name
  gateway_instance_type        = each.value.instance_type
  key_name                     = each.value.key_name
  allocate_and_associate_eip   = true
  volume_size                  = 100
  volume_encryption            = ""
  enable_instance_connect      = false
  disable_instance_termination = false
  instance_tags                = {}

  // --- Check Point Settings ---
  gateway_version                        = each.value.gateway_version
  admin_shell                            = each.value.admin_shell
  gateway_SICKey                         = each.value.gateway_SICKey
  gateway_password_hash                  = each.value.gateway_password_hash
  gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
  // --- Quick connect to Smart-1 Cloud (Recommended) ---
  gateway_TokenKey = ""

  // --- Advanced Settings ---
  resources_tag_name       = "tag-name"
  gateway_hostname         = each.value.gateway_name
  allow_upload_download    = true
  enable_cloudwatch        = false
  gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
  primary_ntp              = ""
  secondary_ntp            = ""

  // --- (Optional) Automatic Provisioning with Security Management Server Settings ---
  control_gateway_over_public_or_private_address = each.value.control_gateway_over_public_or_private_address
  management_server                              = ""
  configuration_template                         = ""
}