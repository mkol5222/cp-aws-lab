variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "keypair_name" {
  description = "Name of the keypair to use for SSH access to the instances"
  type        = string
}

variable "load_balancers_type" {
  description = "Type of load balancers to create (e.g., Network Load Balancer)"
  type        = string
  default     = "Network Load Balancer"
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "lab"
}

# variable "servers_subnets" {
#   description = "List of subnets for the servers"
#   type        = list(string)
# }