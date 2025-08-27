
# EC2 SSH keypair created on demand


resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "cpman-keypair-secondary"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

output "private_key_pem" {
  description = "Private key content (PEM format)"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

# Optional: Write private key to a local file (do NOT commit this file!)
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/../secrets/cpman-keypair-secondary.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}
