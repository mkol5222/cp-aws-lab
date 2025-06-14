variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched."
  type        = string
}
variable "instance_type" {
  description = "The type of instance to launch."
  type        = string
  default     = "t2.micro"
}