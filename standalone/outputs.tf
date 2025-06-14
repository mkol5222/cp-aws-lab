output "ip" {
    value = module.standalone_cp.standalone_public_ip
}

output "ssh" {
    value = module.standalone_cp.standalone_ssh
}

output "url" {
    value = module.standalone_cp.standalone_url
}