variable "linux_routed" {
  description = "Flag to indicate if Linux instance should be routed through a specific ENI"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "keypair_name" {
  description = "Name of the keypair to use for SSH access to the instances"
  type        = string
}

variable "internal_eni_id" {
  description = "The ID of the internal ENI of active cluster member"
  type        = string
  default = null
}