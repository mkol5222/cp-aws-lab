
# lets create dedicated VPC for the cluster 172.17.0.0/16
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.17.0.0/16"
}

# cluster frontend subnet - 172.17.1.0/24
variable "public_subnets_map" {
  description = "Map of public subnets with availability zones"
  type        = map(number)
  default     = {
    "eu-north-1a" = 1
  }
}

# backend subnet - 172.17.2.0/24
variable "private_subnets_map" {
  description = "Map of private subnets with availability zones"
  type        = map(number)
  default     = {
    "eu-north-1a" = 2
  }
}

# subnet mask /24 for public and private subnets
variable "subnets_bit_length" {
  description = "Bit length for subnets"
  type        = number
  default     = 8
}
