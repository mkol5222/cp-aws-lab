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