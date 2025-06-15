# do not implement network here

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
#   default     = "172.18.0.0/16"
# }
# variable "public_subnets_map" {
#   description = "Map of public subnets with availability zones"
#   type        = map(number)
#   default     = {
#     "eu-north-1a" = 1
#   }
# }

# variable "subnets_bit_length" {
#   description = "Bit length for subnets"
#   type        = number
#   default     = 8
# }

# // --- VPC ---
# module "launch_vpc" {

#  count = var.subnet_id == null ? 1 : 0



#  source  = "CheckPointSW/cloudguard-network-security/aws//modules/vpc"

#   vpc_cidr = var.vpc_cidr
#   public_subnets_map = var.public_subnets_map
#   private_subnets_map = {} // var.private_subnets_map
#   subnets_bit_length = var.subnets_bit_length
# }