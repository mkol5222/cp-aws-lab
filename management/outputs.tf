output "ip" {
    // management_public_ip
    value = module.cpman.management_public_ip
}

// management_instance_id
output "id" {
    value = module.cpman.management_instance_id
}

// management_url
output "url" {
    value = module.cpman.management_url
}