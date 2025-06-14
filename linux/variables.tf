variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched."
  type        = string
  default     = null # Replace with your actual subnet ID
}
variable "vpc_id" {
  description = "The ID of the VPC where the instance will be launched."
  type        = string
  default     = null # Replace with your actual subnet ID
}
variable "instance_type" {
  description = "The type of instance to launch."
  type        = string
  default     = "t3.micro"
}

