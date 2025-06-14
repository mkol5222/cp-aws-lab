variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

# public_subnets_map
variable "public_subnets_map" {
  description = "Map of public subnets with availability zones as keys and subnet numbers as values"
  type        = map(number)
  default     = {
    "eu-north-1a" = 1
  }
}

# private_subnets_map
variable "private_subnets_map" {
  description = "Map of private subnets with availability zones as keys and subnet numbers as values"
  type        = map(number)
  default     = {
    "eu-north-1a" = 2
  }
} 

# subnets_bit_length
variable "subnets_bit_length" {
  description = "Bit length for subnets"
  type        = number
  default     = 8
}