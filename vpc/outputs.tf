output "vpc_id" {
  description = "ID of the VPC"
  value       = module.launch_vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.launch_vpc.public_subnets_ids_list
}
output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.launch_vpc.private_subnets_ids_list
}
output "igw_id" {

  value       = module.launch_vpc.aws_igw
}