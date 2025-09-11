
variable "gateway_sic_key" {
  description = "SIC key for the gateway"
  type        = string
  sensitive   = true
}

variable "gateway_admin_password" {
  description = "Admin password for the gateway"
  type        = string
  sensitive   = true
}