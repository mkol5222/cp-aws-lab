provider "aws" {}

// --- VPC ---
module "launch_vpc" {
 source  = "CheckPointSW/cloudguard-network-security/aws//modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_subnets_map = var.public_subnets_map
  private_subnets_map = var.private_subnets_map
  subnets_bit_length = var.subnets_bit_length
}