resource "tls_private_key" "ssh_key" {
  count = var.keypair_name == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count = var.keypair_name == null ? 1 : 0
  key_name   = "cluster-keypair"
  public_key = tls_private_key.ssh_key[0].public_key_openssh
}

output "private_key_pem" {
  
  description = "Private key content (PEM format)"
  value       = var.keypair_name == null ? tls_private_key.ssh_key[0].private_key_pem : null
  sensitive   = true
}

# Optional: Write private key to a local file (do NOT commit this file!)
resource "local_file" "private_key" {
  count = var.keypair_name == null ? 1 : 0
  content              = tls_private_key.ssh_key[0].private_key_pem
  filename             = "${path.module}/../secrets/linux-keypair.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}