output "ip_a" {
  value = module.cluster.member_a_public_ip[0]
}
output "ip_b" {
  value = module.cluster.member_b_public_ip[0]
}
output "ip_clu" {
  value = module.cluster.cluster_public_ip
}

