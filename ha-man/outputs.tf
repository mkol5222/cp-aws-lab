output "ip" {
    // management_public_ip
    value = module.haman.management_public_ip
}

// management_instance_id
output "id" {
    value = module.haman.management_instance_id
}

// management_url
output "url" {
    value = module.haman.management_url
}