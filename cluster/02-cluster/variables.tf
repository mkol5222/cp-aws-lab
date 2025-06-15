variable "vpc_id" {
  description = "ID of the VPC"
}
variable "public_subnets" {
  description = "List of public subnet IDs"
}
variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "keypair_name" {
  description = "Name of the keypair to use for SSH access to the instances"
  type        = string
}