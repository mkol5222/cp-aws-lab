output "ip_a" {
  value = module.cluster.member_a_public_ip[0]
}
output "ip_b" {
  value = module.cluster.member_b_public_ip[0]
}
output "ip_clu" {
  value = module.cluster.cluster_public_ip[0]
}

output "linux_instance_id" {
  value = module.launch_linux.instance_id
}

# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = module.cluster.vpc_id
# }
# output "public_subnets" {
#   description = "List of public subnet IDs"
#   value       = module.cluster.public_subnets_ids_list
# }
# output "private_subnets" {
#   description = "List of private subnet IDs"
#   value       = module.cluster.private_subnets_ids_list
# }

